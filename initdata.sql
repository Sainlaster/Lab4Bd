INSERT INTO Inventory (size) VALUES
(100),
(95),
(80),
(75),
(60);

INSERT INTO Player (nickname, hitpoints, experience, gender, age, money, status, inventoryId) VALUES
('Кирито', 18500, 100000,'Мужской',17, 700000, 'Жив', 1),
('Асуна', 15500, 80000, 'Женский', 18, 120000, 'Жив', 2),
('Кляйн', 12500, 60000, 'Мужской', 25, 90000, 'Жив', 3),
('Силика', 14500, 55000, 'Женский', 14, 80000, 'Жив', 4),
('Эгиль', 18000, 70000, 'Мужской', 17, 135000, 'Жив', 5);

INSERT INTO Item (name, description, drop_method, lvl) VALUES
('Плащ полуночи', 'Кожаный плащ черного цвета, длиной ниже колен', 'Выдается за последнюю атаку по боссу 1-го этажа крепости Айнкрад',10),
('Кристалл телепортации', 'Телепортирует пользователя в главный город этажа', 'Выпадает с моба "Дикий волк" 1-го этажа', 1),
('Сияющий свет', 'Одноручная рапира', 'Выдается за убийство моба "Роковая Коса"', 40),
('Зелье лечения', 'Зелье восстанавливающие  Хитпоитны игрока', 'Выпадает с моба "Кобольт" 1-го этажа', 5),
('Вразумитель','Одноручный черный мечь. Этот меч является одним из лучших клинков демонического класса','Выпадает с босса 50 уровня',50),
('Легендарная удочка','Удочка мастера рыбалки','Выдается за убийство моба "Кит" 35-го этажа', 37),
('Измельчитель','Двуручный боевой топор','Выдается за последнюю атаку по боссу 18-го этажа крепости Айнкрад',19);

INSERT INTO Inventory_Item (inventoryId, itemId) VALUES
(1, 1),
(1, 2),
(1, 4),
(1, 5),
(1, 6),
(2, 2),
(2, 3),
(2, 4),
(2, 6),
(3, 2),
(3, 3),
(3, 4),
(4, 2),
(4, 3),
(4, 4),
(5, 2),
(5, 3),
(5, 6),
(5, 7);

INSERT INTO Armor (itemId, defence_value) VALUES
(1, 500);

INSERT INTO Equipment (itemId, defence_value) VALUES
(2, 1),
(4, 1),
(6, 50);

INSERT INTO Weapons (itemId, damage_value) VALUES
(3, 3732),
(5, 1500);

INSERT INTO Skill (skillId,name, type, drop_method, description) VALUES
(1,'Прямой выпад', 'Ударный', 'Прокачка ветки базового навыка Одноручная рапира', '«Прямой выпад» состоит из одного быстрого прямого удара. Благодаря тому, что навык имеет удивительно небольшую задержку после использования, можно использовать несколько выпадов в цепочке в очень короткий промежуток времени'),
(2,'Вертикальный квадрат', 'Ударный', 'Прокачка ветки базового навыка Одноручный прямой меч', 'Комбо состоит из четырех ударов: вертикальный разрез, потом быстрая пара ударов вверх-вниз и напоследок мощный рубящий удар вверх из-за спины'),
(3,'Катана','Дополнительный','Открывается путем длительного использования "Изогнутого меча"','Открывает новый ряд навыков Катана'),
(4,'Вихрь','Ударный','Прокачка ветки навыка Катана','Состоит из одного разрубающего удара в форме полукруга'),
(5,'Два клинка','Легенарный','Выдается самому быстрому по реакции игроку Sword Art Online','Скрытый навык, открывающий владельцу новый ряд навыков "Двуручный меч"'),
(6,'Крестовидный блок','Оборонительный','Прокачка ветки базового навыка Двуручный меч','Оборонительный навык мечника для двух клинков. Использование: скрестить два клинка так, чтобы вышел крест'),
(7,'Готовка','Базовый','Выдается за успешное прохождение обучения готовки','Позволяет использовать печь'),
(8,'Обнаружение врагов','Пассивый','Выдается за длительную медитацию','Навык увеличивающий радиус поиска. Позволяет игроку обнаруживать возможные засады и других игроков');

INSERT INTO Skill_Player (playerId, skillId) VALUES
(1, 2),(1, 3),(1, 4),(1, 5),
(2, 1),(2, 7),(2, 8),
(3, 3),(3, 4),(3, 8),
(4, 7),(4, 8),
(5, 2),(5, 7),(5, 8);

INSERT INTO Location (name,coordinate) VALUES
('Лабиринт', POINT(45.123456,12.987654)),
('Арена босса',POINT(-73.456789,40.789012)),
('Леденое ущелье', POINT(3.141592,2.718281)),
('Поле', POINT(43.123456,12.987654)),
('Подземелье первого этажа',POINT(-73.456789,40.789012)),
('Океан', POINT(3.141592,24.718281));

INSERT INTO Floor (floorId,name, climate, main_town, status, description) VALUES
(1,'Этаж 1', 'Ясная', 'Стартовый город', 'Открыт', 'Стартовый этаж.'),
(2,'Этаж 2', 'Ветренно', 'Урбус', 'Открыт', 'Главной чертой второго этажа является горная местность, а также обилие разнообразных равнин и скал.'),
(18,'Этаж 18', 'Ветренно', 'Салембург', 'Открыт', 'В основном затопленный уровень с несколькими островами.'),
(35,'Этаж 35', 'Ясная', 'Коралловая деревня', 'Открыт', 'Большинство территории этажа занимают густые леса, равнины и озера'),
(50,'Этаж 50', 'Ясная', 'Флория', 'Открыт', 'Примечателен тем, что почти полностью покрыт всевозможными видами цветов.');

INSERT INTO Boss (name, hitpoints, floor, spawn_point, features, drop_item, teleport_ability,status) VALUES
('Ильфанг', 9500, 1, 1, 'Волкоподобный прямоходящий великан рыжего цвета, в шлеме, вооруженный топором и щитом. На протяжении всего сражения его поддерживают кобольды стражники. Как только последняя шкала хит поинтов босса опускается до трети, он меняет топор и щит на "нодачи", что позволяло использовать навыки катаны.', 1, true,'Мёртв'),
('Страшный Бивень', 23425, 18, 2, 'Гигантский кабан, способный ходить на двух задних лапах, у него зеленая кожа и красные глаза.', 7, true,'Жив'),
('Крфан Белый змей ', 120000, 50, 3, 'Морозный белый дракон, способен производить редкий минерал под названием "кристаллический слиток", который формировался внутри его тела', 3, true,'Жив');

INSERT INTO Mob (name, hitpoints, floor, features, drop_item,spawn_point) VALUES
('Дикий волк', 500, 1,  'Запрещает использования зелья лечения на 20 секунд', 2,4),
('Роковая Коса', 10000, 1, 'Запрещает телепортацию, накладывает эффект оцепенение', 3,5),
('Кит', 3400, 35,  'Самая редкая рыба, шанс выловить 0.001%', 6,6);

INSERT INTO ExistMobs (mobId,status) VALUES
(1,'Жив'),(1,'Жив'),(1,'Жив'),(1,'Жив'),(1,'Жив'),(1,'Жив'),(1,'Жив'),(1,'Мёртв'),(1,'Жив'),(1,'Жив'),
(2,'Жив'),
(3,'Жив'),(3,'Жив'),(3,'Жив'),(3,'Жив'),(3,'Жив'),(3,'Жив');