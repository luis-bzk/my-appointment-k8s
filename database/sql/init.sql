-- latin countries
insert into
    core.core_country (cou_name, cou_code, cou_prefix, cou_record_status)
values
    ('argentina', '+54', 'ar', '0'),
    ('bolivia', '+591', 'bo', '0'),
    ('brazil', '+55', 'br', '0'),
    ('chile', '+56', 'cl', '0'),
    ('colombia', '+57', 'co', '0'),
    ('costa rica', '+506', 'cr', '0'),
    ('cuba', '+53', 'cu', '0'),
    ('dominican republic', '+1-809', 'do', '0'),
    ('ecuador', '+593', 'ec', '0'),
    ('el salvador', '+503', 'sv', '0'),
    ('guatemala', '+502', 'gt', '0'),
    ('honduras', '+504', 'hn', '0'),
    ('mexico', '+52', 'mx', '0'),
    ('nicaragua', '+505', 'ni', '0'),
    ('panama', '+507', 'pa', '0'),
    ('paraguay', '+595', 'py', '0'),
    ('peru', '+51', 'pe', '0'),
    ('puerto rico', '+1-787', 'pr', '0'),
    ('uruguay', '+598', 'uy', '0'),
    ('venezuela', '+58', 've', '0');

commit;

-- provinces ecuador
insert into
    core.core_province (
        pro_name,
        pro_code,
        id_country,
        pro_prefix,
        pro_record_status
    )
values
    ('azuay', '01', 9, 'az', '0'),
    ('bolívar', '02', 9, 'bo', '0'),
    ('cañar', '03', 9, 'ca', '0'),
    ('carchi', '04', 9, 'cr', '0'),
    ('chimborazo', '05', 9, 'ch', '0'),
    ('cotopaxi', '06', 9, 'co', '0'),
    ('el oro', '07', 9, 'eo', '0'),
    ('esmeraldas', '08', 9, 'es', '0'),
    ('galápagos', '09', 9, 'ga', '0'),
    ('guayas', '10', 9, 'gu', '0'),
    ('imbabura', '11', 9, 'im', '0'),
    ('loja', '12', 9, 'lo', '0'),
    ('los ríos', '13', 9, 'lr', '0'),
    ('manabí', '14', 9, 'ma', '0'),
    ('morona santiago', '15', 9, 'ms', '0'),
    ('napo', '16', 9, 'na', '0'),
    ('orellana', '17', 9, 'or', '0'),
    ('pastaza', '18', 9, 'pa', '0'),
    ('pichincha', '19', 9, 'pi', '0'),
    ('santa elena', '20', 9, 'se', '0'),
    (
        'santo domingo de los tsáchilas',
        '21',
        9,
        'sd',
        '0'
    ),
    ('sucumbíos', '22', 9, 'su', '0'),
    ('tungurahua', '23', 9, 'tu', '0'),
    ('zamora chinchipe', '24', 9, 'zc', '0');

-- provinces colombia
insert into
    core.core_province (
        pro_name,
        pro_code,
        id_country,
        pro_prefix,
        pro_record_status
    )
values
    ('amazonas', '01', 5, 'ama', '0'),
    ('antioquia', '02', 5, 'ant', '0'),
    ('arauca', '03', 5, 'ara', '0'),
    ('atlántico', '04', 5, 'atl', '0'),
    ('bolívar', '05', 5, 'bol', '0'),
    ('boyacá', '06', 5, 'boy', '0'),
    ('caldas', '07', 5, 'cal', '0'),
    ('caquetá', '08', 5, 'caq', '0'),
    ('casanare', '09', 5, 'cas', '0'),
    ('cauca', '10', 5, 'cau', '0'),
    ('cesar', '11', 5, 'ces', '0'),
    ('chocó', '12', 5, 'cho', '0'),
    ('córdoba', '13', 5, 'cor', '0'),
    ('cundinamarca', '14', 5, 'cun', '0'),
    ('guainía', '15', 5, 'gua', '0'),
    ('guaviare', '16', 5, 'guv', '0'),
    ('huila', '17', 5, 'hui', '0'),
    ('la guajira', '18', 5, 'lgu', '0'),
    ('magdalena', '19', 5, 'mag', '0'),
    ('meta', '20', 5, 'met', '0'),
    ('nariño', '21', 5, 'nar', '0'),
    ('norte de santander', '22', 5, 'nsa', '0'),
    ('putumayo', '23', 5, 'put', '0'),
    ('quindío', '24', 5, 'qui', '0'),
    ('risaralda', '25', 5, 'ris', '0'),
    ('san andrés y providencia', '26', 5, 'sap', '0'),
    ('santander', '27', 5, 'san', '0'),
    ('sucre', '28', 5, 'suc', '0'),
    ('tolima', '29', 5, 'tol', '0'),
    ('valle del cauca', '30', 5, 'vca', '0'),
    ('vaupés', '31', 5, 'vau', '0'),
    ('vichada', '32', 5, 'vic', '0');

commit;

-- cities ecuador
-- azuay (id 1)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('cuenca', 9, 1, '0'),
    ('gualaceo', 9, 1, '0'),
    ('paute', 9, 1, '0'),
    ('sígsig', 9, 1, '0'),
    ('chordeleg', 9, 1, '0');

-- bolívar (id 2)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('guaranda', 9, 2, '0'),
    ('chillanes', 9, 2, '0'),
    ('chimbo', 9, 2, '0'),
    ('echeandía', 9, 2, '0'),
    ('san miguel', 9, 2, '0');

-- cañar (id 3)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('azogues', 9, 3, '0'),
    ('biblián', 9, 3, '0'),
    ('cañar', 9, 3, '0'),
    ('la troncal', 9, 3, '0'),
    ('el tambo', 9, 3, '0');

-- carchi (id 4)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('tulcán', 9, 4, '0'),
    ('bolívar', 9, 4, '0'),
    ('espejo', 9, 4, '0'),
    ('mira', 9, 4, '0'),
    ('montúfar', 9, 4, '0');

-- chimborazo (id 5)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('riobamba', 9, 5, '0'),
    ('alausí', 9, 5, '0'),
    ('chambo', 9, 5, '0'),
    ('chunchi', 9, 5, '0'),
    ('guamote', 9, 5, '0');

-- cotopaxi (id 6)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('latacunga', 9, 6, '0'),
    ('la maná', 9, 6, '0'),
    ('pangua', 9, 6, '0'),
    ('pujilí', 9, 6, '0'),
    ('salcedo', 9, 6, '0');

-- el oro (id 7)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('machala', 9, 7, '0'),
    ('arenillas', 9, 7, '0'),
    ('atahualpa', 9, 7, '0'),
    ('balsas', 9, 7, '0'),
    ('chilla', 9, 7, '0');

-- esmeraldas (id 8)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('esmeraldas', 9, 8, '0'),
    ('atacames', 9, 8, '0'),
    ('eloy alfaro', 9, 8, '0'),
    ('muisne', 9, 8, '0'),
    ('quinindé', 9, 8, '0');

-- galápagos (id 9)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('puerto ayora', 9, 9, '0'),
    ('puerto baquerizo moreno', 9, 9, '0'),
    ('puerto villamil', 9, 9, '0');

-- guayas (id 10)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('guayaquil', 9, 10, '0'),
    ('durán', 9, 10, '0'),
    ('milagro', 9, 10, '0'),
    ('samborondón', 9, 10, '0'),
    ('daule', 9, 10, '0');

-- imbabura (id 11)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('ibarra', 9, 11, '0'),
    ('antonio ante', 9, 11, '0'),
    ('cotacachi', 9, 11, '0'),
    ('otavalo', 9, 11, '0'),
    ('pimampiro', 9, 11, '0');

-- loja (id 12)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('loja', 9, 12, '0'),
    ('calvas', 9, 12, '0'),
    ('catamayo', 9, 12, '0'),
    ('celica', 9, 12, '0'),
    ('chaguarpamba', 9, 12, '0');

-- los ríos (id 13)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('babahoyo', 9, 13, '0'),
    ('buena fe', 9, 13, '0'),
    ('quevedo', 9, 13, '0'),
    ('vinces', 9, 13, '0'),
    ('ventanas', 9, 13, '0');

-- manabí (id 14)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('portoviejo', 9, 14, '0'),
    ('manta', 9, 14, '0'),
    ('chone', 9, 14, '0'),
    ('bahía de caráquez', 9, 14, '0'),
    ('jipijapa', 9, 14, '0');

-- morona santiago (id 15)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('macas', 9, 15, '0'),
    ('gualaquiza', 9, 15, '0'),
    ('huamboya', 9, 15, '0'),
    ('limón indanza', 9, 15, '0'),
    ('santiago', 9, 15, '0');

-- napo (id 16)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('tena', 9, 16, '0'),
    ('archidona', 9, 16, '0'),
    ('el chaco', 9, 16, '0'),
    ('quijos', 9, 16, '0'),
    ('carlos julio arosemena tola', 9, 16, '0');

-- orellana (id 17)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('francisco de orellana', 9, 17, '0'),
    ('aguarico', 9, 17, '0'),
    ('la joya de los sachas', 9, 17, '0'),
    ('loreto', 9, 17, '0');

-- pastaza (id 18)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('puyo', 9, 18, '0'),
    ('mera', 9, 18, '0'),
    ('santa clara', 9, 18, '0'),
    ('arajuno', 9, 18, '0');

-- pichincha (id 19)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('quito', 9, 19, '0'),
    ('cayambe', 9, 19, '0'),
    ('mejía', 9, 19, '0'),
    ('pedro moncayo', 9, 19, '0'),
    ('rumiñahui', 9, 19, '0');

-- santa elena (id 20)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('santa elena', 9, 20, '0'),
    ('la libertad', 9, 20, '0'),
    ('salinas', 9, 20, '0');

-- santo domingo de los tsáchilas (id 21)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('santo domingo', 9, 21, '0'),
    ('la concordia', 9, 21, '0');

-- sucumbíos (id 22)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('nueva loja', 9, 22, '0'),
    ('cascales', 9, 22, '0'),
    ('cuyabeno', 9, 22, '0'),
    ('gonzalo pizarro', 9, 22, '0'),
    ('lago agrio', 9, 22, '0');

-- tungurahua (id 23)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('ambato', 9, 23, '0'),
    ('baños de agua santa', 9, 23, '0'),
    ('cevallos', 9, 23, '0'),
    ('mocha', 9, 23, '0'),
    ('patate', 9, 23, '0');

-- zamora chinchipe (id 24)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('zamora', 9, 24, '0'),
    ('chinchipe', 9, 24, '0'),
    ('nangaritza', 9, 24, '0'),
    ('yacuambi', 9, 24, '0'),
    ('yantzaza', 9, 24, '0');

-- cities colombia
-- amazonas (id 1)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('leticia', 5, 1, '0'),
    ('puerto nariño', 5, 1, '0');

-- antioquia (id 2)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('medellín', 5, 2, '0'),
    ('bello', 5, 2, '0'),
    ('itagüí', 5, 2, '0'),
    ('envigado', 5, 2, '0'),
    ('apartadó', 5, 2, '0');

-- arauca (id 3)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('arauca', 5, 3, '0'),
    ('arauquita', 5, 3, '0'),
    ('saravena', 5, 3, '0');

-- atlántico (id 4)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('barranquilla', 5, 4, '0'),
    ('soledad', 5, 4, '0'),
    ('malambo', 5, 4, '0');

-- bolívar (id 5)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('cartagena', 5, 5, '0'),
    ('magangué', 5, 5, '0'),
    ('turbaco', 5, 5, '0');

-- boyacá (id 6)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('tunja', 5, 6, '0'),
    ('duitama', 5, 6, '0'),
    ('sogamoso', 5, 6, '0');

-- caldas (id 7)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('manizales', 5, 7, '0'),
    ('villamaría', 5, 7, '0'),
    ('chinchiná', 5, 7, '0');

-- caquetá (id 8)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('florencia', 5, 8, '0'),
    ('san vicente del caguán', 5, 8, '0');

-- casanare (id 9)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('yopal', 5, 9, '0'),
    ('aguazul', 5, 9, '0'),
    ('villanueva', 5, 9, '0');

-- cauca (id 10)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('popayán', 5, 10, '0'),
    ('santander de quilichao', 5, 10, '0'),
    ('guapi', 5, 10, '0');

-- cesar (id 11)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('valledupar', 5, 11, '0'),
    ('aguachica', 5, 11, '0'),
    ('bosconia', 5, 11, '0');

-- chocó (id 12)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('quibdó', 5, 12, '0'),
    ('istmina', 5, 12, '0'),
    ('riosucio', 5, 12, '0');

-- córdoba (id 13)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('montería', 5, 13, '0'),
    ('cereté', 5, 13, '0'),
    ('sahagún', 5, 13, '0');

-- cundinamarca (id 14)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('bogotá', 5, 14, '0'),
    ('soacha', 5, 14, '0'),
    ('girardot', 5, 14, '0');

-- guainía (id 15)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('inírida', 5, 15, '0');

-- guaviare (id 16)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('san josé del guaviare', 5, 16, '0');

-- huila (id 17)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('neiva', 5, 17, '0'),
    ('pitalito', 5, 17, '0'),
    ('garzón', 5, 17, '0');

-- la guajira (id 18)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('riohacha', 5, 18, '0'),
    ('maicao', 5, 18, '0'),
    ('uribia', 5, 18, '0');

-- magdalena (id 19)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('santa marta', 5, 19, '0'),
    ('ciénaga', 5, 19, '0'),
    ('fundación', 5, 19, '0');

-- meta (id 20)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('villavicencio', 5, 20, '0'),
    ('acacías', 5, 20, '0'),
    ('granada', 5, 20, '0');

-- nariño (id 21)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('pasto', 5, 21, '0'),
    ('tumaco', 5, 21, '0'),
    ('ipiales', 5, 21, '0');

-- norte de santander (id 22)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('cúcuta', 5, 22, '0'),
    ('ocaña', 5, 22, '0'),
    ('pamplona', 5, 22, '0');

-- putumayo (id 23)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('mocoa', 5, 23, '0'),
    ('puerto asís', 5, 23, '0');

-- quindío (id 24)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('armenia', 5, 24, '0'),
    ('calarcá', 5, 24, '0'),
    ('la tebaida', 5, 24, '0');

-- risaralda (id 25)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('pereira', 5, 25, '0'),
    ('dosquebradas', 5, 25, '0'),
    ('santa rosa de cabal', 5, 25, '0');

-- san andrés y providencia (id 26)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('san andrés', 5, 26, '0'),
    ('providencia', 5, 26, '0');

-- santander (id 27)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('bucaramanga', 5, 27, '0'),
    ('floridablanca', 5, 27, '0'),
    ('barrancabermeja', 5, 27, '0');

-- sucre (id 28)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('sincelejo', 5, 28, '0'),
    ('corozal', 5, 28, '0'),
    ('sampués', 5, 28, '0');

-- tolima (id 29)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('ibagué', 5, 29, '0'),
    ('espinal', 5, 29, '0'),
    ('melgar', 5, 29, '0');

-- valle del cauca (id 30)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('cali', 5, 30, '0'),
    ('palmira', 5, 30, '0'),
    ('buenaventura', 5, 30, '0');

-- vaupés (id 31)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('mitú', 5, 31, '0');

-- vichada (id 32)
insert into
    core.core_city (
        cit_name,
        id_country,
        id_province,
        cit_record_status
    )
values
    ('puerto carreño', 5, 32, '0');

commit;

------------------- users -------------------
insert into
    core.core_user (
        use_name,
        use_last_name,
        use_email,
        use_password,
        use_token,
        use_created_date,
        use_record_status
    )
values
    (
        'luis',
        'berrezueta',
        'luis@gmail.com',
        'password',
        null,
        current_timestamp,
        '0'
    );

insert into
    core.core_user (
        use_name,
        use_last_name,
        use_email,
        use_password,
        use_token,
        use_created_date,
        use_record_status
    )
values
    (
        'maria',
        'sanchez',
        'msanchexz@gmail.com',
        'password',
        null,
        current_timestamp,
        '0'
    );

insert into
    core.core_user (
        use_name,
        use_last_name,
        use_email,
        use_password,
        use_token,
        use_created_date,
        use_record_status
    )
values
    (
        'andres',
        'montero',
        'amontero192@gmail.com',
        'password',
        null,
        current_timestamp,
        '0'
    );

insert into
    core.core_user (
        use_name,
        use_last_name,
        use_email,
        use_password,
        use_token,
        use_created_date,
        use_record_status
    )
values
    (
        'jina',
        'ferrero',
        'jianaafer@gmail.com',
        'password',
        null,
        current_timestamp,
        '0'
    );

commit;

------------------- roles -------------------
insert into
    core.core_role (
        rol_name,
        rol_description,
        rol_created_date,
        rol_record_status
    )
values
    ('admin', 'admin role', current_timestamp, '0');

insert into
    core.core_role (
        rol_name,
        rol_description,
        rol_created_date,
        rol_record_status
    )
values
    (
        'developer',
        'developer role',
        current_timestamp,
        '0'
    );

insert into
    core.core_role (
        rol_name,
        rol_description,
        rol_created_date,
        rol_record_status
    )
values
    ('user', 'user role', current_timestamp, '0');

insert into
    core.core_role (
        rol_name,
        rol_description,
        rol_created_date,
        rol_record_status
    )
values
    ('doctor', 'user role', current_timestamp, '0');

insert into
    core.core_role (
        rol_name,
        rol_description,
        rol_created_date,
        rol_record_status
    )
values
    ('patient', 'user role', current_timestamp, '0');

commit;

------------------- user roles -------------------
insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 1, 1);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 1, 2);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 1, 3);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 2, 3);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 2, 4);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 3, 3);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 3, 5);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 4, 3);

insert into
    core.core_user_role (
        uro_created_date,
        uro_record_status,
        id_user,
        id_role
    )
values
    (current_timestamp, '0', 4, 5);

commit;

------------------- genre -------------------
insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    (
        'masculino',
        'genero masculino',
        'm',
        current_timestamp,
        '0'
    );

insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    (
        'femenino',
        'genero femenino',
        'f',
        current_timestamp,
        '0'
    );

insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    (
        'no binario',
        'genero no binario',
        'nb',
        current_timestamp,
        '0'
    );

insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    ('gay', 'genero gay', 'g', current_timestamp, '0');

insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    (
        'lesbiana',
        'genero lesbiana',
        'l',
        current_timestamp,
        '0'
    );

insert into
    core.core_genre (
        gen_name,
        gen_description,
        gen_abbreviation,
        gen_created_date,
        gen_record_status
    )
values
    (
        'trans',
        'genero transexual',
        't',
        current_timestamp,
        '0'
    );

commit;

------------------- identification type -------------------
insert into
    core.core_identification_type (
        ity_name,
        ity_description,
        ity_abbreviation,
        ity_created_date,
        ity_record_status,
        id_country
    )
values
    (
        'cédula',
        'cédula de identificación ecuatoriana',
        'ci',
        current_timestamp,
        '0',
        (
            select
                cc.cou_id
            from
                core.core_country cc
            where
                cc.cou_prefix = 'ec'
        )
    );

insert into
    core.core_identification_type (
        ity_name,
        ity_description,
        ity_abbreviation,
        ity_created_date,
        ity_record_status,
        id_country
    )
values
    (
        'pasaporte',
        'pasaporte ecuatoriano',
        'pp',
        current_timestamp,
        '0',
        (
            select
                cc.cou_id
            from
                core.core_country cc
            where
                cc.cou_prefix = 'ec'
        )
    );

commit;

------------------- phone type -------------------
insert into
    core.core_phone_type (
        pty_name,
        pty_description,
        pty_created_date,
        pty_record_status
    )
values
    (
        'principal',
        'número de teléfono principal',
        current_timestamp,
        '0'
    );

insert into
    core.core_phone_type (
        pty_name,
        pty_description,
        pty_created_date,
        pty_record_status
    )
values
    (
        'hogar',
        'número de teléfono del hogar',
        current_timestamp,
        '0'
    );

insert into
    core.core_phone_type (
        pty_name,
        pty_description,
        pty_created_date,
        pty_record_status
    )
values
    (
        'secundario',
        'número de teléfono adicional',
        current_timestamp,
        '0'
    );

commit;

------------------- notification type -------------------
insert into
    core.core_notification_type (
        nty_name,
        nty_description,
        nty_created_date,
        nty_record_status
    )
values
    (
        'alerta',
        'mensaje de alerta',
        current_timestamp,
        '0'
    );

insert into
    core.core_notification_type (
        nty_name,
        nty_description,
        nty_created_date,
        nty_record_status
    )
values
    (
        'error',
        'mensaje de error',
        current_timestamp,
        '0'
    );

insert into
    core.core_notification_type (
        nty_name,
        nty_description,
        nty_created_date,
        nty_record_status
    )
values
    (
        'recordatorio',
        'mensaje para recordar',
        current_timestamp,
        '0'
    );

commit;