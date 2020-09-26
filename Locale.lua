local SS_TEXT = {
    melee = 'Ближний бой',
    range = 'Дальний бой',
    magic = 'Чародейство',
    religion = 'Вера',
    perfomance = 'Выступление',
    missing = 'Избегание',
    hands = 'Ловкость рук',
    athletics = 'Атлетика',
    observation = 'Внимательность',
    knowledge = 'Знание',
    controll = 'Самоконтроль',
    judgment = 'Суждение',
    acrobats = 'Акробатика',
    stealth = 'Скрытность',
    power = 'Мощь',
    accuracy = 'Точность',
    wisdom = 'Мудрость',
    morale = 'Мораль',
    empathy = 'Эмпатия',
    mobility = 'Подвижность',
    precision = 'Аккуратность',
};

function SS_Locale(word)
    return SS_TEXT[word] or 'NO LOCALE';
end;