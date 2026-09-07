import 'package:appshop/modules/categorias/models/categorias_model.dart';
import 'package:appshop/modules/categorias/widgets/categoria_icon_helper.dart';
import 'package:flutter/material.dart';

class CategoryRoundels extends StatelessWidget {
  final List<CategoriasModel> categorias;
  final ValueChanged<String> onCategorySelected;

  CategoryRoundels({
    required this.categorias,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return SizedBox();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Pesquise por categoria",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onCategorySelected(categoria.id),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 24,
                        child: Icon(
                          CategoriaIconHelper.getIcon(categoria.nome),
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        categoria.nome,
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
