/*import 'package:flutter/material.dart';
import 'widgets/offer_card.dart';

class PublicOffersScreen extends StatefulWidget {
  // PublicOffersScreen empty constructor
  const PublicOffersScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PublicOffersScreen> {
  final items = List<String>.generate(20, (i) => "Obra de Arte $i");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return OfferCard(
          title: items[index],
          content:
              'Estamos buscando un desarrollador backend independiente de NodeJS para trabajar en el backend de una aplicación nativa de Android. Alguien que pueda ayudarnos en la creación de una aplicación móvil de redes sociales basada en video desde cero. Este sería un puesto remunerado con la opción de trabajar desde casa. Una oportunidad de aprender y desarrollar algo desde cero.',
          arch: 'Artista $index',
          level: 'Ciudad X',
          payment: 3000000,
          onCopy: () => {},
          onApply: () => {},
        );
      },
    );
  }
}
*/

//
// la clase OfferCard en la ruta content/public_offers/widgests/offer_card.dart NO SE ESTA UTILIZANDO
//
import 'package:flutter/material.dart';
import 'package:simple_sample_3/data/services/anime_pool.dart';
import 'package:simple_sample_3/domain/models/anime_model.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimePoolService service = AnimePoolService();
    Future<List<AnimeModel>> futureJobs = service.fecthData();
    return FutureBuilder<List<AnimeModel>>(
      future: futureJobs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              AnimeModel anime = items[index];
              return Card(
                child: Row(
                  children: [
                    Image.network(anime.posterUrl),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Titulo: ${anime.title}"),
                          const SizedBox(
                            height: 7,
                          ),
                          //Text("Descripcion: ${anime.description}"),
                          Text("Numero de episodios: ${anime.episodeCount}"),
                          Text("Estado: ${anime.status}"),
                          Text("Clasificacion: ${anime.ageRating}"),
                          Text("Tipo: ${anime.showType}")
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
