# Проект 0. Курс: DST-PRO
# Поток: 
#
# Задача: попробуйте улучшить алгоритм автора модуля
# 
# Автор: https://github.com/13gi
# Репозиторий: https://github.com/13gi/ds-skf
#
# Аннтоация
#   game_core_v3
#     алгоритм V3: угадывает число в среднем за 7 попыток.
#
#   game_core_v4
#     алгоритм V4: угадывает число в среднем за 5 попыток.



# -------------------------------------------
#  Начальные условия
# -------------------------------------------
# Диапазон чисел для игры - указываем границы слева (входит) и справа(не входит в диапазон)

range_border_left = 1
range_border_right = 101


def score_game(game_core):
    ''' Функция расчета среднего результата.
        Запускаем игру 1000 раз, чтобы узнать, как быстро игра угадывает число'''
    # инициируем массив, в который соберем потребовашееся количество попыток для отгдаывания числа
    count_ls = []
    
    # фиксируем RANDOM SEED, чтобы ваш эксперимент был воспроизводим!
    np.random.seed(1)  
    
    # наполняем массив случайными числами для угадывания
    random_array = np.random.randint(1,101, size=(1000))
    
    # запускаем циклически функция отгадывания числа и собираем массив из количества попыток
    for number in random_array:
        count_ls.append(game_core(number))
    
    # получаем среднее значение числа попыток
    score_mean = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за {score_mean} попыток")
    # возращаем среднее число попыток
    return(score_mean)




def game_core_v3(number):
    ''' Сначала берем середину промежетука, а потом сдвигаем границы влево или в право, чтобы брать random число
        из постоянно сжимающегося промежутка вокруг загаданного числа '''
    
    count = 1
    shifting_range_left = range_border_left
    shifting_range_right = range_border_right
    
    predict = shifting_range_right // 2
    
    while number != predict:
        #print(f"Алгоритм №3: х = {number}. Попытка {count}: random число {predict} из диапазона [{shifting_range_left},{shifting_range_right})")
        if number > predict: 
            shifting_range_left = predict + 1
        elif number < predict: 
            shifting_range_right = predict
        
        predict = np.random.randint(shifting_range_left, shifting_range_right)
        count += 1
    # выход из цикла, если угадали    
    #print(f"Бинго! Угадано за {count} попыток")
    return(count) 



def game_core_v4(number):
    ''' Сначала берем серидину промежетука, а потом сдвигаем границы влево или вправо, берем опять серидину промежутка.
        таким образом делим всегда промежуток пополоам пока не дойдем до искомого числа'''
    
    count = 1
    shifting_range_left = range_border_left
    shifting_range_right = range_border_right
    
    predict = shifting_range_right//2
    
    while number != predict:
        if number > predict: 
            shifting_range_left = predict
        elif number < predict: 
            shifting_range_right = predict
        
        predict = (shifting_range_right + shifting_range_left)//2
        count += 1
    # выход из цикла, если угадали    
    return(count) 




# запускаем

score_game(game_core_v3)

score_game(game_core_v4)


