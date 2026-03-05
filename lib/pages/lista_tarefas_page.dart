
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gerenciador_de_tarefas/model/tarefa.dart';
import 'package:gerenciador_de_tarefas/widgets/conteudo_form_dialog.dart';

class ListaTarefasPage extends StatefulWidget{

  @override
  _ListaTarefasPageState createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage>{

  static const ACAO_EDITAR = 'Editar';
  static const ACAO_EXCLUIR = 'Excluir';

  final _tarefas = <Tarefa>[
    Tarefa(id: 1, descricao: 'Fazer atividade avaliativa 1',
        prazo: DateTime.now().add(const Duration(days: 5))),
  ];

  var ultimoId = 0;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      title: const Text('Tarefas'),
      actions: [
        IconButton(
          onPressed: (){},
          icon: const Icon(Icons.list),
        )
      ],
    );
  }

  Widget _criarBody(){
    if(_tarefas.isEmpty){
      return const Center(
        child: Text('Nenhuma tarefa encontrada!!!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _tarefas.length,
      itemBuilder: (BuildContext context, int index){
        final tarefa = _tarefas[index];
        return PopupMenuButton(
          child: ListTile(
              title: Text('${tarefa.id} - ${tarefa.descricao}'),
              subtitle: Text('Prazo: ${tarefa.prazoFormatado}'
              ),
          ),
          itemBuilder: (BuildContext context) => criarItemMenuPopUp(),
          onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_EDITAR){
              _abrirForm(tarefaAtual: tarefa, indice: index);
            } else {
              _excluir(index);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  List<PopupMenuEntry<String>>criarItemMenuPopUp(){
    return [
      PopupMenuItem<String>(
          value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding (
                padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_EXCLUIR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding (
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          )
      )
    ];
  }

  void _excluir(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.amber,),
              Padding(
                padding: EdgeInsets.only(left:10),
                child: Text('Atenção'),
              )
            ]
          ),
          content: Text('Esse registro será excluido definitivamente!'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar')
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _tarefas.removeAt(index);
                  });
                },
                child: const Text('Ok')
            )
          ],
        );
      }
    );
  }

  void _abrirForm({Tarefa? tarefaAtual, int? indice}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(tarefaAtual == null ? 'Nova Tarefa' :
            'Alterar a tarefa: ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: (){
                  if (key.currentState != null && key.currentState!.dadosValidados()){
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;
                      if (indice == null){
                        novaTarefa.id = ++ ultimoId;
                        _tarefas.add(novaTarefa);
                      }else{
                        _tarefas[indice] = novaTarefa;
                      }
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        }
    );
  }
}