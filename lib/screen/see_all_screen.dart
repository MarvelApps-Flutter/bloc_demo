import 'package:flutter/material.dart';
import '../bloc/see_all_screen_bloc/see_all_screen_bloc.dart';
import '../model/popular_movies_model.dart';
import '../widget/common_component.dart';
import '../widget/styles.dart';

import 'description_screen.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late SeeAllScreenBloc _bloc;
  @override
  void initState() {
    _bloc = SeeAllScreenBloc()..add(InitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.seeAllData,
        builder: (context, AsyncSnapshot<Movies?> snapshot) {
          return Scaffold(
            backgroundColor: const Color(0xFF171A2F),
            body: snapshot.hasData
                ? _body(context, snapshot.data!)
                : const Center(child: CircularProgressIndicator()),
          );
        });
  }

  Stack _body(context, Movies data) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 60,
              ),
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 3,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.results!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _movieListTile(context, data, index);
                    }),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).padding.top + 100,
          color: const Color(0xFF171A2F),
        ),
        Column(children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 15, right: 15),
            child: _customAppbar(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text('Popular Movies', style: Styles.style7),
            ),
          )
        ]),
      ],
    );
  }

  FractionallySizedBox _movieListTile(
      BuildContext context, Movies data, int index) {
    return FractionallySizedBox(
      widthFactor: 0.97,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => DescriptionScreen(
                          movieID: data.results![index].id,
                          isfavourite: data.results![index].favourite,
                        )),
              );
            },
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFF1F2340),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: data.results![index].posterPath == null
                          ? Colors.grey.shade400
                          : null,
                    ),
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: data.results![index].posterPath == null
                          ? Center(
                              child: Text(
                                data.results![index].originalTitle.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Image.network(
                              data.results![index].fullImageUrl,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(data.results![index].originalTitle.toString(),
                          style: Styles.style14),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.play_circle_outline_sharp,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.transparent,
            height: 4,
          ),
        ],
      ),
    );
  }

  Widget _customAppbar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          CommonComponent.iconCard(context, Icons.person,
              color: const Color(0xFF1F2340)),
        ],
      ),
    );
  }
}
