//
//  QuestServiceExtension.swift
//  gorene
//
//  Created by Illya Blinov on 12.05.24.
//

extension QuestService {

    func servicesQuestInitial(){ //Добавляем служебные, пустые квесты. Позволяет выполнить некоторый код в нужный момент времени. Например переключить ветку изходя из ранее сделанного выбора

        //MARK: test DesiralizationService
        let mocQuest = QuestModel(questName: "Test").getQuest()
        let ruPrologue = QuestModel(questName: "ruPrologue", questStates: noJSONQuestsState(questName: "ruPrologue"))
        let mocStateCollection = QuestStateCollection(questName: ruPrologue.questName, questStates: ruPrologue.questStates)
        let mocData = DesiralizationService.questStateEncode(questStates: mocStateCollection)
        guard let mocData else {return}
        let stringData = String(data: mocData, encoding: .utf8)
        guard let stringData else {return}
        //print(stringData)

        let jsonQuestCollection = DesiralizationService.questStateDecode(data: mocData)
        if let jsonQuestCollection {
            let jsonQuest = QuestModel(questName: jsonQuestCollection.questName, questStates: jsonQuestCollection.questStates)
            addQuest(quest: jsonQuest)
            changeQuest(newQuest: jsonQuest.questName)
        }
        //MARK: end test



        addQuest(quest: QuestModel(questName: "QuestBranching01",
                                   questStart: { player, service in
        }))
        addQuest(quest: QuestModel(questName: "QuestBranching02",
                                   questStart: { player, service in
        }))

    }

    func findQuest(questName: String) -> Int?{
        quests.firstIndex(where: {$0.questName == questName})
    }

    func noJSONQuestsState(questName: String) -> [QuestState]{
        var questState = [QuestState]()
        if questName == "ruPrologue" {
            questState = [
                QuestState(stateId: 0,
                           showImage: QuestStateShowImage(
                            image: "prologue001",
                            duration: 10,
                            description: "Это начало пролога. Тебя ждет долгий путь \nПрими верные решение!",
                            changingParameters: ["discipline" : 1]),
                           background: "prologue001",
                           mainText:"Я не оправдал надежды. Всё больше времени я провожу в одиночестве, меня одолевает апатия, всё больше сижу дома и страдаю ерундой.\nОтец всё чаще по вечерам уходит из дома и возвращается со странным запахом под утро. С лица матери же совсем пропала улыбка.\nОна часто ругается на него, отец в свою очередь не может из себя выдавить больше чем мычания. Мне грустно видеть близких в таком состоянии.",
                           actions: [
                            ActionStruct(actionText: "Побыть с отцом",
                                         actionDesctiption: "Это шанс улучшить взаимоотношение с отцом, а возможно и чему-то у него научиться!",
                                         requiredParameters: ["relFather" : 2, "energy" : 2],
                                         sumOfParameters: ["oratory" : 7, "flexibility" : 6],
                                         actionNextState: 1),
                            ActionStruct(actionText: "Бездельничать",
                                         actionNextState: 2),
                            ActionStruct(actionText: "Побыть с матерью",
                                         actionNextState: 3),
                            ActionStruct(actionText: "Помоч семье",
                                         requiredParameters: ["coins" : 2],
                                         changingParameters: ["coins" : -2],
                                         actionNextState: 1),
                            ActionStruct(actionText: "Заниматься физкультурой",
                                         requiredParameters: ["discipline" : 8],
                                         actionNextState: 4)
                           ]),
                QuestState(stateId: 1, mainText: "Отец всё меньше похож на себя прежнего. От него вечно чем-то странно пахло. Мысли его были спутаны и часто, алогичны. Если раньше его размышления всегда стали продиктованы логикой, иногда странной и не понятной мне, но мысли были стройные и выстраивались в цепочки, то сейчас часто он говорит абсолютно иррациональные вещи. От моего отца осталась только бледная тень.\nС отцом мы ходим по каким-то странным людям, он им предлагает какую-то странную смесь. Меня удивляли некоторые места куда отец брал меня и с каким людьми он меня знакомил, но отец на мои вопросы об этом сказал тебе могут пригодится эти связи когда меня не станет. Однажды мы встретились с его другом Федом. Он радостно меня поприветствовал, а потом они удалились обсуждать с отцом, что-то на повышенных тонах, кажется Фед чему-то был не доволен. Ближе к вечеру отец оставлял меня не надолго и что-то делал.\nОбычно вечера мы с отцом изучали книжку о парах, даже пару раз делали эксперементы из неё. Мне нравилось проводить время с отцом, несмотря на то что приходилось общаться с не лицеприятными людьми.",
                           actions: [
                            ActionStruct(actionText: "Далее",
                                         changingParameters: ["relFather" : 1, "technology" : 2, "oratory" : 2, "energy" : -2],
                                         actionNextState: 5)
                           ]),
                QuestState(stateId: 2, mainText:
                """
                Каждое утро я просыпался и ничего не делал. Иногда меня посещали мысли, что нужно заняться собой, помочь матери по хозяйству пока отец где-то пропадает, но это всё рушилось от моего категорического нежелания.
                Я ненавидел себя за то что дни ничего не делал и ничего не делал потому что, ненавидел себя. Мне казалось если я начну продвигаться в каком-то направлении меня обязательно ждёт провал, поэтому лучше ничего не делать и быть спокойным, а в своих фантазиях представлять себя сильнейшем героем, умнейшем учёным. Апатия стала моим лучшим другом и как иначе я в ней не жил, я в ней утопал. Каждый день, кормя её как хороший хозяин и она во мне разрасталась всё больше. В определённые дни я не хотел шевелиться, что же говорить о контакте с людьми за пределом моего дома. Родители смотрели на меня разочарованным взглядом, пару раз мать мне говорила, чем-нибудь заняться, но я делал вид и вновь подавался абулии.
                Друзья обзавелись своими компаниями на своём новом жизненном этапе. Однажды всё же решили ко мне зайти, я подозреваю мать или отец попросили их об этом. Я вышел к ним сухо спросил как дела, ответил на их аналогичный вопрос и поспешил завершить диалог. Они меня звали погулять, про себя очень хотел пойти с ними, но моя питомица уже во всю хозяйничала и я тупя взор отказал им.
                Может сэкономленные силы помогут к будущем свершениям.
                """,
                           actions: [
                            ActionStruct(actionText: "Далее",
                                         changingParameters: ["energy" : 4, "relFather" : -2, "relMother" : -2, "oratory" : -2, "flexibility" : -2,  "strength" : -2, "discipline" : -2],
                                         actionNextState: 5)
                           ]),
                QuestState(stateId: 3, mainText:
                """
                Мать практически всё время тратить на работу по дому. Кажется, она стала  делать это с большим усердием, те свободные минуты которые выпадают, она проводит на то что переписывает священные тексты единства или молитве, такое ощущения мать себя корит в чём-то и так в виде усердной работы и религии она видит своё очищения.
                В один день я встал как у меня повелось в последнее время ближе к обеду и вижу мать, которая ели движется по комнате, я говорю ей лечь, а сам начинаю готовить за неё под материным чётким контролем. Моя мама заболела. Отца постоянно не было дома, поэтому мне пришлось всю работу по дому взять на себя. Несмотря на то что моя мать была в весьма плачевном состоянии, она пыталась контролировать каждый мой шаг. Первые дни мне не нравилось выполнять рутинную работу и я часто убирал вещи как можно быстрее, больше делал вид, чем работал. Мать это часто замечала и делала мне замечания: "Только в порядке единство" - говорила она каждый раз когда я выполнял свою работу спустя рукава. С каждым днём выполняю одну и туже работу ловил себя на мысли, что она получается у меня всё лучше и я стал получать блаженство от хорошо выполненной работы и с каждым днём выполнял её более усердно. Мать глядя на мои успехи поправилась, и снова основная работа легла на неё. Мать не могла остаться в стороне, вить она хозяйка этого дома, её эфоский дух не дал бы пустить всё на самотек, но я теперь не оставался в стороне постоянно помогал матери, часто выполнял плотническую работу. Чинил мебель, забивал гвозди рубил деревья и т.п. Вечерами я с матерью переписывал тексты и молился.
                Уставая от работы, я не понимал, почему должен своё свободное время тратить на религию страны в которой не живу, но каждый день нёс моральное удовлетворение, я чувствовал себя полезным и не одиноким, вить меня вели Трое и я был с ними един, как и с тысячью даже миллионами таких же.
                """,
                           actions: [
                            ActionStruct(actionText: "Далее",
                                         changingParameters: ["energy" : -2, "relMother" : 1, "discipline" : 2, "literacy" : 2],
                                         actionNextState: 5)
                           ]),
                QuestState(stateId: 4, mainText:
                """
                Растекаясь каждый день в кровати, моё тело практически состояло из жира, у меня не было никаких амбиций, я хотел только лежать. Но в один из дней я увидел на улице статного воина и мне захотелось стать подобным ему.
                Я вспомнил про упражнения которые мне показывала мать, да половину из них я не мог выполнить. Каждое моё движение было отягощено, оно было резкое, такое ощущения, что в каждом упражнения я выполнял лишь половину из нужной амплитуды. Я стал делать упражнения каждый день, мне казалось что у меня нет прогресса и я из себя представляю такого же жирного увальня, как и был раньше. Но я продолжал свои попытки. Как-то взглянув на себя в зеркало, я увидел существенный прогресс и это придало мне мотивацию заниматься больше.
                Кажется, я стал действительно сильнее.
                """,
                           actions: [
                            ActionStruct(actionText: "Далее",
                                         changingParameters: ["strength" : 2, "discipline" : 2, "contemplation" : -2],
                                         actionNextState: 5)
                           ]),
                QuestState(stateId: 5, mainText:
                """
                Большинство друзей перестали со мной общаться, у них появились новые друзья в семинарах. Мне всё меньше охота раскрывать рот. Моё мнение кажется настолько незначительным, что я предпочитаю его не высказывать.
                """,
                           actions: [
                            ActionStruct(actionText: "Далее",
                                         changingParameters: ["strength" : -1, "oratory" : -2, "flexibility" : -2],
                                         actionNextState: 6)
                           ]),

            ]
        }
        return questState
    }
}
