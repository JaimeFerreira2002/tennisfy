import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';

class TennisSetup extends StatefulWidget {
  const TennisSetup({Key? key}) : super(key: key);

  @override
  State<TennisSetup> createState() => _TennisSetupState();
}

class _TennisSetupState extends State<TennisSetup> {
  int _questionSelected = 0; //used to keep track of withc quastions the user is
  //be aware thet questionSelectd is from 0 to 2

  //list of each of the three options the user  choose
  final List<int> _optionsSelected = [0, 0, 0];
  final List<List<String>> _answersList = [
    ["Begginer", "Intermidiate", "Advanced", "Professional"],
    ["0 - 6 months", "6 months - 1 year", "1 - 3 years", "3+ years"],
    ["0 - 5", "5 - 10", "10 - 20", "20+"]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: displayHeight(context) * 0.35,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About Tennis",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back))
                      ],
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.01),
                  Text(
                    "Now let's get a fell for your tennis level. For us to be able to provide you with the best experience possible, we ask you to answer the following questions as honestly as possible.",
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            ),
          ),
          //this values have to add up to 0,85, to put the green container in the bottom of the page
          Container(
            height: displayHeight(context) * 0.35,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        _question(0, _answersList[0],
                            "How experienced would you consider yourself ?"),
                        _question(1, _answersList[1],
                            "For how long have you been playing ?"),
                        _question(2, _answersList[2],
                            "How often do you play or practice ?"),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: displayWidth(context) * 0.1,
                            height: displayHeight(context) * 0.008,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1),
                                color: _questionSelected == 0
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.transparent),
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Container(
                            width: displayWidth(context) * 0.1,
                            height: displayHeight(context) * 0.008,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1),
                                color: _questionSelected == 1
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.transparent),
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Container(
                            width: displayWidth(context) * 0.1,
                            height: displayHeight(context) * 0.008,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1),
                                color: _questionSelected == 2
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.transparent),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity: _questionSelected != 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          //when the button doesnt have a shadow, the container is unecessary, just use TextButton, but for some reason, color doens t work on buttonStyle
                          width: displayWidth(context) * 0.1,
                          height: displayHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _questionSelected--;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Container(
                        //when the button doesnt have a shadow, the container is unecessary, just use TextButton, but for some reason, color doens t work on buttonStyle
                        width: displayWidth(context) * 0.3,
                        height: displayHeight(context) * 0.05,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextButton(
                            onPressed: () {
                              if (_questionSelected == 2) {
                              } else {
                                setState(() {
                                  _questionSelected++;
                                });
                              }
                            },
                            child: Text(
                              _questionSelected == 2 ? "Finish" : "Next",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: displayHeight(context) * 0.3,
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: displayHeight(context) * 0.10,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutBack,
                left: displayWidth(context) * 0.2 -
                    _questionSelected * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_serve_cartoon.png",
                  scale: 1.6,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutBack,
                top: displayHeight(context) * 0.09,
                left: displayWidth(context) * 0.16 -
                    (_questionSelected - 1) * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_net_cartoon.png",
                  scale: 6,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutBack,
                left: displayWidth(context) * 0.2 -
                    (_questionSelected - 2) * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_reciever_cartoon.png",
                  scale: 1.1,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

//each of the answers row, qeuestionnumber is to know with of the questions the row is, answer number is to know with of the answers it is
  Padding _QuestionRowButton(
      int questionNumber, int answerNumber, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _optionsSelected[questionNumber] = answerNumber;
              });
            },
            child: Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _optionsSelected[questionNumber] == answerNumber
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 54, 54, 54),
                      width: 1.6)),
            ),
          ),
          SizedBox(
            width: displayWidth(context) * 0.08,
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  AnimatedPositioned _question(
      int questionNumber, List<String> answers, String question) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCirc,
      left: _questionSelected == questionNumber
          ? displayWidth(context) * 0.06
          : _questionSelected - questionNumber > 0
              ? -displayWidth(context) * 0.8 * (questionNumber + 1)
              : displayWidth(context) * 0.8 * (questionNumber + 1),
      child: Container(
        width: displayWidth(context) * 0.8,
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text(question)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _QuestionRowButton(questionNumber, 1, answers[0]),
                  _QuestionRowButton(questionNumber, 2, answers[1]),
                  _QuestionRowButton(questionNumber, 3, answers[2]),
                  _QuestionRowButton(questionNumber, 4, answers[3])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
