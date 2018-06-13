# Сервис данных заявителей

Приложение предоставляет REST API для оперирования данными заявителей.

## Вызов отладочной консоли и тестов

Для вызова отладочной консоли и тестов рекомендуется использовать виртуальную
машину, которую можно запустить с помощью команды `vagrant up` в терминале
(здесь и далее подразумевается, что текущий путь терминала указывает на
корневую директорию Git-репозитория приложения). После создания, запуска и
настройки виртуальной машины необходимо зайти в неё с помощью команды
`vagrant ssh`. Следующие команды выполняются в терминале виртуальной машины:

*   `bundle install` — установка необходимых библиотек после создания
    виртуальной машины;
*   `make debug` — запуск отладочной IRB-консоли;
*   `make test` — запуск тестов;

## Настройка

Приложение поддерживает настройку с помощью переменных окружения. При
разработке часть переменных окружений загружается из файлов `.env.*`,
находящихся в корневой директории.

### Настройки журнала событий

*   `CAB_LOG_LEVEL` — режим отображения событий. Поддерживаются следующие
    значения:
    -   `debug` — отображение всех сообщений, в том числе отладочных (режим по
        умолчанию);
    -   `info` — отображение информационных сообщений и сообщений об ошибках;
    -   `error` — отображение только сообщений об ошибках;
    -   `unknown` — отключение отображения событий.

## Документация исходного кода

Исходный код прокомментирован с помощью [`yard`](https://yardoc.org), что
позволяет создать документацию в HTML-формате. Для этого необходимо выполнить
команду `make doc` в терминале виртуальной машины. Документация будет создана в
директории `doc`.
