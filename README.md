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
*   `make migrate` — создание необходимых таблиц в базе данных;
*   `make debug` — запуск отладочной IRB-консоли;
*   `make test` — запуск тестов;
*   `make run` — запуск приложения.

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

### Настройки REST-контроллера

*   `CAB_BIND_HOST` — адрес сервиса
*   `CAB_PORT` — порт сервиса
*   `CAB_PUMA_WORKERS` — количество дочерних процессов обработки запросов (по
    умолчанию принимает значение 4).
*   `CAB_PUMA_THREADS_MIN` — минимальное количество потоков обработки запросов
    (по умолчанию принимает значение 0).
*   `CAB_PUMA_THREADS_MAX` — максимальное количество потоков обработки запросов
    (по умолчанию принимает значение 8).

### Настройки подключения к базе данных

*   `CAB_DB_USER` — пользователь базы данных
*   `CAB_DB_PASS` — пароль базы
*   `CAB_DB_HOST` — адрес сервера баз данных
*   `CAB_DB_NAME` — название базы данных

## Миграция базы данных

Следующие команды управляют миграциями базы данных.

*   `make migrate` — миграция базы данных на последнюю версию схемы базы
    данных. Повторное выполнение команды не приводит к миграции.

*   `bundle exec rake cab:migrate[0]` — миграция базы данных, приводящая
    к удалению всех таблиц, индексов и типов, необходимых для выполнения
    приложения.

## Перенос данных заявителей из старого сервиса

Приложение предоставляет функционал переноса данных заявителей из старого
сервиса личного кабинета заявителя. Для этого необходимо выполнить команду

```
bundle exec rake cab:transfer
```

Информация о старом сервисе и файловом хранилище извлекается из следующих
переменных окружения:

*   `OLDCAB_DB_USER` — пользователь базы данных;
*   `OLDCAB_DB_PASS` — пароль базы;
*   `OLDCAB_DB_HOST` — адрес сервера баз данных;
*   `OLDCAB_DB_NAME` — название базы данных;
*   `SHD_HOST` — адрес файлового хранилища;
*   `SHD_PORT` — порт файлового хранилища.

После успешного выполнения команды в директории `tmp` создаётся CSV-файл с
информацией о записях, которые не удалось перенести, и о причинах неудачи.
Информация о расположении этого файла также выводится на терминал.

## Документация исходного кода

Исходный код прокомментирован с помощью [`yard`](https://yardoc.org), что
позволяет создать документацию в HTML-формате. Для этого необходимо выполнить
команду `make doc` в терминале виртуальной машины. Документация будет создана в
директории `doc`.

## Дополнительная документация

*   [Настройка нечёткого поиска](./docs/FUZZY.md)
