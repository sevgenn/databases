USE furniture_company;

INSERT INTO adresses VALUES
(NULL, 'Moscow', 'Arbat, 5'),
(NULL, 'Somecity', 'Somestreet, 29'),
(NULL, 'Somecity', 'Anystreet, 7'),
(NULL, 'Mycity', 'Luckystreet, 10'),
(NULL, 'Mycity', 'Happyavenue, 11'),
(NULL, 'Somecity', 'Westavenue, 45'),
(NULL, 'Somecity', 'Nordstreet, 57'),
(NULL, 'Mycity', 'Goodavenue, 90'),
(NULL, 'Mycity', 'Greenstreet, 15'),
(NULL, 'Somecity', 'Silentstreet, 24'),
(NULL, 'Somecity', 'Nicestreet, 101'),
(NULL, 'Somecity', 'Fineavenue, 19'),
(NULL, 'Mycity', 'Joystreet, 12'),
(NULL, 'Mycity', 'Gladavenue, 35'),
(NULL, 'Mycity', 'Pleasurestreet, 27'),
(NULL, 'Somecity', 'Fortunestreet, 30');

INSERT INTO persons VALUES
(NULL, 'Petrov', 'Petr', 'Petrovich', 1, 89251111111, 89031111111, 'petr@mail.com'),
(NULL, 'Ivanov', 'Ivan', 'Ivanovich', 2, 89252222222, 89102222222, 'ivan@mail.com'),
(NULL, 'Sidorov', 'Sidor', 'Sidorovich', 3, 89163333333, 89053333333, 'sidor@mail.com'),
(NULL, 'Smith', 'John', NULL, 4, 89254444444, NULL, 'john@mail.com'),
(NULL, 'Brando', 'Marlon', NULL, 5, 89165555555, NULL, 'brando@mail.com'),
(NULL, 'Pacino', 'Alfredo', 'James', 6, 89156666666, NULL, 'alpacino@mail.com'),
(NULL, 'Gibson', 'Mel', 'Gerard', 7, 89257777777, NULL, 'gibson@mail.com'),
(NULL, 'De Niro', 'Robert', 'Anthony', 8, 89038888888, NULL, 'deniro@mail.com'),
(NULL, 'Marciano', 'Rocky', NULL, 9, 89259999999, NULL, NULL);

INSERT INTO shops VALUES
(NULL, '1-shop', 10),
(NULL, '2-shop', 11),
(NULL, '3-shop', 12);

INSERT INTO vendors VALUES
(NULL, '1-vendor', 13),
(NULL, '2-vendor', 14);

INSERT INTO managers VALUES
(NULL, 1, 1),
(NULL, 2, 2),
(NULL, 3, 3);

INSERT INTO media VALUES
(NULL, 'handles.jpg', NULL, NULL),
(NULL, 'countertops.jpg', NULL, NULL),
(NULL, 'style_1.jpg', NULL, NULL),
(NULL, 'style_2.jpg', NULL, NULL),
(NULL, 'style_3.jpg', NULL, NULL),
(NULL, 'common_photo.jpg', NULL, NULL),
(NULL, '400x720.jpg', NULL, NULL),
(NULL, '450x720.jpg', NULL, NULL),
(NULL, '600x720.jpg', NULL, NULL),
(NULL, 'handle_knob.jpg', NULL, NULL),
(NULL, 'handle_grip.jpg', NULL, NULL),
(NULL, 'countertop-1.jpg', NULL, NULL),
(NULL, 'countertop-2.jpg', NULL, NULL),
(NULL, 'thumb_400x720.jpg', NULL, NULL),
(NULL, 'thumb_600x720.jpg', NULL, NULL),
(NULL, 'cupboard_400x720.jpg', NULL, NULL),
(NULL, 'cupboard_600x720.jpg', NULL, NULL),
(NULL, 'order_1.dwg', NULL, NULL),
(NULL, 'order_2.cad', NULL, null),
(NULL, 'order_3.dwg', NULL, null);

INSERT INTO classes VALUES
(NULL, 'facade'),
(NULL, 'furniture'),
(NULL, 'body');

INSERT INTO categories VALUES
(NULL, 'handles', 'Ðó÷êè', 1, 2),
(NULL, 'countertops', 'Ñòîëåøíèöû', 2, 2),
(NULL, 'style-1', 'Ôàñàäû ýêîíîì', 3, 1),
(NULL, 'style-2', 'Ôàñàäû ïëàñòèê', 3, 1),
(NULL, 'style-3', 'Ôàñàäû ìàññèâ', 5, 1),
(NULL, 'body_economy', 'Êîðïóñ ËÄÑÏ', 6, 3),
(NULL, 'body_premium', 'Êîðïóñ ÌÄÔ', 6, 3);

INSERT INTO products VALUES
(NULL, 'facade 400x720', 'Ôàñàä 400õ720', 7, 3),
(NULL, 'facade 450x720', 'Ôàñàä 450õ720', 8, 3),
(NULL, 'facade 600x720', 'Ôàñàä 600õ720', 9, 3),
(NULL, 'facade 400x720', 'Ôàñàä 400õ720', 7, 5),
(NULL, 'facade 450x720', 'Ôàñàä 450õ720', 8, 5),
(NULL, 'facade 600x720', 'Ôàñàä 600õ720', 9, 5),
(NULL, 'handle-1', 'Ðó÷êà-êíîïêà', 10, 1),
(NULL, 'handle-2', 'Ðó÷êà-ñêîáà', 11, 1),
(NULL, 'countertop-1', 'Ñòîëåøíèöà ÄÑÏ ìðàìîð', 12, 2),
(NULL, 'countertop-2', 'Ñòîëåøíèöà êàìåíü ìðàìîð', 13, 2),
(NULL, 'thumb 400x720', 'Òóìáà 400õ720', 14, 6),
(NULL, 'thumb 600x720', 'Òóìáà 600õ720', 15, 6),
(NULL, 'cupboard 400x720', 'Øêàô 400õ720', 14, 6),
(NULL, 'cupboard 600x720', 'Øêàô 600õ720', 15, 6);

INSERT INTO prices VALUES
(1, '2019-12-01', 1000.00),
(2, '2019-12-01', 1500.00),
(3, '2019-12-01', 2000.00),
(4, '2019-12-01', 1500.00),
(5, '2019-12-01', 2000.00),
(6, '2019-12-01', 2000.00),
(7, '2019-12-01', 50.00),
(8, '2019-12-01', 100.00),
(9, '2019-12-01', NULL),
(10, '2019-12-01', NULL),
(11, '2019-12-01', 1000.00),
(12, '2019-12-01', 1500.00),
(13, '2019-12-01', 1000.00),
(14, '2019-12-01', 1500.00);

INSERT INTO storehouse VALUES
(NULL, 7, 20),
(NULL, 8, 10);

INSERT INTO customers VALUES
(NULL, 'John', 4),
(NULL, 'Father', 5),
(NULL, 'Al Pacino', 6),
(NULL, 'Mel', 7);

INSERT INTO orders VALUES
(NULL, 1, 1, '2020-02-01', NULL, 'agreed', 'full', 16, NULL),
(NULL, 2, 3, '2019-12-01', NULL, 'completed', 'no', 17, NULL),
(NULL, 3, 2, '2019-12-01', '2020-01-30', 'placed', 'full', 18, NULL),
(NULL, 4, 1, '2020-01-15', NULL, 'agreed', 'prepay', 16, NULL);

INSERT INTO order_product VALUES
(1, 11, 3),
(1, 12, 2),
(1, 13, 3),
(1, 14, 2),
(1, 1, 6),
(1, 3, 4),
(1, 7, 10),
(1, 9, 1),
(2, 11, 2),
(2, 12, 2),
(2, 13, 2),
(2, 14, 2),
(2, 4, 4),
(2, 6, 4),
(2, 8, 8),
(2, 10, 1),
(3, 11, 5),
(3, 13, 5),
(3, 8, 10),
(3, 10, 1),
(3, 4, 10),
(4, 11, 2),
(4, 12, 2),
(4, 13, 2),
(4, 14, 2),
(4, 4, 4),
(4, 6, 4),
(4, 8, 8),
(4, 10, 1);

INSERT INTO discounts VALUES
(NULL, 0.75, 5, '2020-03-01', '2020-03-10');

INSERT INTO supplies VALUES
(NULL, 1, '2020-03-01'),
(NULL, 2, '2020-03-01');

INSERT INTO supply_product VALUES
(1, 1, 4),
(1, 2, 4),
(2, 11, 4),
(2, 12, 4);

INSERT INTO deliveries VALUES
(NULL, 'accepted', 2000.00, 4, 1),
(NULL, 'completed', 1500.00, 5, 2),
(NULL, 'accepted', 2000.00, 6, 3);

INSERT INTO assemblies VALUES
(NULL, 'accepted', 5000.00, 4, 1),
(NULL, 'completed', 4000.00, 5, 2),
(NULL, 'accepted', 5000.00, 6, 3);










