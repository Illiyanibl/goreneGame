ru
Это текстовая игра основанная на выборе игрока, изменний его характера, умений и возникающих последствий этого выбора.
</br>Действие игры происходит в загадочном мире Theos (рабочее название), полном загадок и событий которые постоянно преледуют главного героя.
</br>Писатели Дмитрий Г. Евгений П., Андрей Д.
</br>Менеджер проекта, редактор Дмитрий Г.
</br>Разработка, тест, технический консультант Illiyanibl
<img width="449" alt="Пример1" src="https://github.com/user-attachments/assets/2ddee9a3-941e-4f22-863d-d2602b225bd5" />
<img width="456" alt="Пример2" src="https://github.com/user-attachments/assets/3c65f79d-3152-4bd6-aa5a-8d4b5a7367a8" />
</br>Технически игра представляет собой интерпретатор json файла (плеер игры), где доступ к действиям игрока определяется харакетристиками игрока а так же последовательностью предыдущих выборов.
</br>Основу игры обеспечивает QuestService с функциями changeState(newState: Int) и changeQuest(newQuest: String, newState: Int = 0 они обеспечивают переход по дереву json файла а так же переход между этими файлами.

