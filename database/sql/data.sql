create schema data;

create table
  data.data_person (
    per_id serial primary key,
    per_identification_number varchar(20) not null,
    per_first_name varchar(50) not null,
    per_second_name varchar(50),
    per_first_last_name varchar(50) not null,
    per_second_last_name varchar(50),
    per_occupation varchar(100),
    per_created_date timestamp default current_timestamp,
    per_record_status varchar(1) not null default '0',
    id_identification_type int not null,
    id_genre int not null,
    id_user int not null,
    constraint fk1_data_person foreign key (id_identification_type) references core.core_identification_type (ity_id),
    constraint fk2_data_person foreign key (id_genre) references core.core_genre (gen_id),
    constraint fk3_data_person foreign key (id_user) references core.core_user (use_id)
  );

create index idx_data_person_identification on data.data_person (per_identification_number);

create index idx_data_person_user on data.data_person (id_user);

create index idx_data_person_identification_type on data.data_person (id_identification_type);

create index idx_data_person_genre on data.data_person (id_genre);

create index idx_data_person_status on data.data_person (per_record_status);

-- Índice para búsquedas por nombre
create index idx_data_person_name on data.data_person (per_first_name, per_first_last_name);

create table
  data.data_phone (
    pho_id serial primary key,
    pho_number varchar(13) not null,
    pho_created_date timestamp default current_timestamp,
    pho_record_status varchar(1) not null default '0',
    id_person int not null,
    id_phone_type int not null,
    constraint fk1_data_phone foreign key (id_person) references data.data_person (per_id),
    constraint fk2_data_phone foreign key (id_phone_type) references core.core_phone_type (pty_id)
  );

create index idx_data_phone_person on data.data_phone (id_person);

create index idx_data_phone_type on data.data_phone (id_phone_type);

create index idx_data_phone_number on data.data_phone (pho_number);

-- Para búsquedas por teléfono
create table
  data.data_address_type (
    aty_id serial primary key,
    aty_name varchar(100) not null,
    aty_description varchar(100),
    aty_created_date timestamp default current_timestamp,
    aty_record_status varchar(1) not null default '0'
  );

create table
  data.data_address (
    add_id serial primary key,
    add_main_street varchar(150) not null,
    add_secondary_street varchar(100),
    add_postal_code varchar(20),
    add_reference varchar(150) not null,
    add_number varchar(10),
    add_created_date timestamp default current_timestamp,
    add_record_status varchar(1) not null default '0',
    id_country int not null,
    id_province int not null,
    id_city int not null,
    id_person int,
    id_address_type int not null,
    constraint fk1_data_address foreign key (id_country) references core.core_country (cou_id),
    constraint fk2_data_address foreign key (id_province) references core.core_province (pro_id),
    constraint fk3_data_address foreign key (id_city) references core.core_city (cit_id),
    constraint fk4_data_address foreign key (id_person) references data.data_person (per_id),
    constraint fk5_data_address foreign key (id_address_type) references data.data_address_type (aty_id)
  );

create index idx_data_address_country on data.data_address (id_country);

create index idx_data_address_province on data.data_address (id_province);

create index idx_data_address_city on data.data_address (id_city);

create index idx_data_address_person on data.data_address (id_person);

create index idx_data_address_type on data.data_address (id_address_type);

-- Índice compuesto para búsquedas geográficas
create index idx_data_address_location on data.data_address (id_country, id_province, id_city);

-- ================================================
-- 1. GESTIÓN DE AGENCIAS INMOBILIARIAS (Multi-tenant)
-- ================================================
create table
  data.data_real_estate_agency (
    rea_id serial primary key,
    rea_name varchar(200) not null,
    rea_business_name varchar(200) not null,
    rea_ruc varchar(13) not null unique,
    rea_email varchar(100) not null,
    rea_phone varchar(13),
    rea_website varchar(200),
    rea_logo_url varchar(300),
    rea_description text,
    rea_office_hours jsonb, -- {"monday": "08:00-18:00", "tuesday": "08:00-18:00", ...}
    rea_commission_percentage numeric(5, 2) default 3.00,
    rea_created_date timestamp default current_timestamp,
    rea_record_status varchar(1) not null default '0',
    id_owner int not null,
    id_address int not null,
    constraint fk1_data_real_estate_agency foreign key (id_owner) references core.core_user (use_id),
    constraint fk2_data_real_estate_agency foreign key (id_address) references data.data_address (add_id)
  );

create index idx_real_estate_agency_ruc on data.data_real_estate_agency (rea_ruc);

create index idx_real_estate_agency_owner on data.data_real_estate_agency (id_owner);

create table
  data.data_agent (
    age_id serial primary key,
    age_license_number varchar(50) not null,
    age_specialization varchar(100), -- residential, commercial, luxury, rentals
    age_commission_rate numeric(5, 2),
    age_hire_date date not null,
    age_active_listings int default 0,
    age_total_sales int default 0,
    age_total_rentals int default 0,
    age_created_date timestamp default current_timestamp,
    age_record_status varchar(1) not null default '0',
    id_real_estate_agency int not null,
    id_person int not null,
    constraint fk1_data_agent foreign key (id_real_estate_agency) references data.data_real_estate_agency (rea_id),
    constraint fk2_data_agent foreign key (id_person) references data.data_person (per_id),
    constraint uk1_data_agent unique (id_real_estate_agency, id_person)
  );

create index idx_agent_agency on data.data_agent (id_real_estate_agency);

create index idx_agent_license on data.data_agent (age_license_number);

-- 2. GESTIÓN DE PROPIEDADES
-- ================================================
create table
  data.data_property_type (
    pty_id serial primary key,
    pty_name varchar(100) not null, -- casa, departamento, terreno, local comercial, oficina
    pty_description varchar(200),
    pty_created_date timestamp default current_timestamp,
    pty_record_status varchar(1) not null default '0'
  );

create table
  data.data_property_status (
    pst_id serial primary key,
    pst_name varchar(50) not null, -- disponible, reservado, vendido, alquilado, en_mantenimiento
    pst_description varchar(200),
    pst_created_date timestamp default current_timestamp,
    pst_record_status varchar(1) not null default '0'
  );

create table
  data.data_property (
    pro_id serial primary key,
    pro_title varchar(200) not null,
    pro_description text,
    pro_cadastral_code varchar(50),
    pro_year_built int,
    pro_total_area numeric(10, 2), -- metros cuadrados
    pro_built_area numeric(10, 2), -- metros cuadrados
    pro_land_area numeric(10, 2), -- metros cuadrados
    pro_bedrooms int,
    pro_bathrooms numeric(3, 1), -- permite medios baños
    pro_parking_spaces int default 0,
    pro_floors int default 1,
    pro_sale_price numeric(12, 2),
    pro_rental_price numeric(10, 2),
    pro_maintenance_fee numeric(10, 2),
    pro_property_tax numeric(10, 2),
    pro_is_furnished boolean default false,
    pro_allows_pets boolean default false,
    pro_virtual_tour_url varchar(300),
    pro_video_url varchar(300),
    pro_created_date timestamp default current_timestamp,
    pro_record_status varchar(1) not null default '0',
    id_real_estate_agency int not null,
    id_property_type int not null,
    id_property_status int not null,
    id_address int not null,
    id_owner int, -- propietario actual
    id_agent int, -- agente asignado
    constraint fk1_data_property foreign key (id_real_estate_agency) references data.data_real_estate_agency (rea_id),
    constraint fk2_data_property foreign key (id_property_type) references data.data_property_type (pty_id),
    constraint fk3_data_property foreign key (id_property_status) references data.data_property_status (pst_id),
    constraint fk4_data_property foreign key (id_address) references data.data_address (add_id),
    constraint fk5_data_property foreign key (id_owner) references data.data_person (per_id),
    constraint fk6_data_property foreign key (id_agent) references data.data_agent (age_id)
  );

create index idx_property_agency on data.data_property (id_real_estate_agency);

create index idx_property_type on data.data_property (id_property_type);

create index idx_property_status on data.data_property (id_property_status);

create index idx_property_agent on data.data_property (id_agent);

create index idx_property_price_range on data.data_property (pro_sale_price, pro_rental_price);

-- 3. CARACTERÍSTICAS Y SERVICIOS DE PROPIEDADES
-- ================================================
create table
  data.data_amenity (
    ame_id serial primary key,
    ame_name varchar(100) not null, -- piscina, gimnasio, seguridad 24h, etc
    ame_category varchar(50), -- seguridad, recreación, servicios
    ame_icon varchar(50),
    ame_created_date timestamp default current_timestamp,
    ame_record_status varchar(1) not null default '0'
  );

create table
  data.data_property_amenity (
    pam_id serial primary key,
    pam_created_date timestamp default current_timestamp,
    pam_record_status varchar(1) not null default '0',
    id_property int not null,
    id_amenity int not null,
    constraint fk1_data_property_amenity foreign key (id_property) references data.data_property (pro_id),
    constraint fk2_data_property_amenity foreign key (id_amenity) references data.data_amenity (ame_id),
    constraint uk1_data_property_amenity unique (id_property, id_amenity)
  );

create index idx_property_amenity_property on data.data_property_amenity (id_property);

create index idx_property_amenity_amenity on data.data_property_amenity (id_amenity);

create table
  data.data_property_image (
    pim_id serial primary key,
    pim_url varchar(300) not null,
    pim_title varchar(200),
    pim_description text,
    pim_is_main boolean default false,
    pim_sort_order int default 0,
    pim_created_date timestamp default current_timestamp,
    pim_record_status varchar(1) not null default '0',
    id_property int not null,
    constraint fk1_data_property_image foreign key (id_property) references data.data_property (pro_id)
  );

create index idx_property_image_property on data.data_property_image (id_property);

-- 4. GESTIÓN DE CLIENTES Y LEADS
-- ================================================
create table
  data.data_client_type (
    clt_id serial primary key,
    clt_name varchar(50) not null, -- comprador, vendedor, arrendador, arrendatario
    clt_description varchar(200),
    clt_created_date timestamp default current_timestamp,
    clt_record_status varchar(1) not null default '0'
  );

create table
  data.data_client (
    cli_id serial primary key,
    cli_budget_min numeric(12, 2),
    cli_budget_max numeric(12, 2),
    cli_preferred_locations text, -- JSON array de zonas preferidas
    cli_property_requirements text, -- JSON con requerimientos específicos
    cli_move_in_date date,
    cli_financing_approved boolean default false,
    cli_notes text,
    cli_created_date timestamp default current_timestamp,
    cli_record_status varchar(1) not null default '0',
    id_real_estate_agency int not null,
    id_person int not null,
    id_client_type int not null,
    id_agent int,
    constraint fk1_data_client foreign key (id_real_estate_agency) references data.data_real_estate_agency (rea_id),
    constraint fk2_data_client foreign key (id_person) references data.data_person (per_id),
    constraint fk3_data_client foreign key (id_client_type) references data.data_client_type (clt_id),
    constraint fk4_data_client foreign key (id_agent) references data.data_agent (age_id)
  );

create index idx_client_agency on data.data_client (id_real_estate_agency);

create index idx_client_person on data.data_client (id_person);

create index idx_client_agent on data.data_client (id_agent);

create index idx_client_budget on data.data_client (cli_budget_min, cli_budget_max);

create table
  data.data_lead_source (
    les_id serial primary key,
    les_name varchar(100) not null, -- web, referido, walk-in, publicidad
    les_description varchar(200),
    les_created_date timestamp default current_timestamp,
    les_record_status varchar(1) not null default '0'
  );

create table
  data.data_lead_status (
    lst_id serial primary key,
    lst_name varchar(50) not null, -- nuevo, contactado, calificado, negociando, cerrado, perdido
    lst_description varchar(200),
    lst_sort_order int default 0,
    lst_created_date timestamp default current_timestamp,
    lst_record_status varchar(1) not null default '0'
  );

create table
  data.data_lead (
    lea_id serial primary key,
    lea_interest_level varchar(20), -- alto, medio, bajo
    lea_contact_preference varchar(50), -- email, phone, whatsapp
    lea_best_time_to_contact varchar(50),
    lea_notes text,
    lea_created_date timestamp default current_timestamp,
    lea_record_status varchar(1) not null default '0',
    id_client int not null,
    id_lead_source int not null,
    id_lead_status int not null,
    id_property int, -- propiedad de interés inicial
    constraint fk1_data_lead foreign key (id_client) references data.data_client (cli_id),
    constraint fk2_data_lead foreign key (id_lead_source) references data.data_lead_source (les_id),
    constraint fk3_data_lead foreign key (id_lead_status) references data.data_lead_status (lst_id),
    constraint fk4_data_lead foreign key (id_property) references data.data_property (pro_id)
  );

create index idx_lead_client on data.data_lead (id_client);

create index idx_lead_status on data.data_lead (id_lead_status);

create index idx_lead_property on data.data_lead (id_property);

-- 5. VISITAS Y SEGUIMIENTO
-- ================================================
create table
  data.data_appointment_type (
    apt_id serial primary key,
    apt_name varchar(50) not null, -- visita_presencial, visita_virtual, reunión, firma_contrato
    apt_description varchar(200),
    apt_created_date timestamp default current_timestamp,
    apt_record_status varchar(1) not null default '0'
  );

create table
  data.data_appointment (
    app_id serial primary key,
    app_date date not null,
    app_time time not null,
    app_duration int default 60, -- minutos
    app_notes text,
    app_status varchar(20) default 'scheduled', -- scheduled, completed, cancelled, no_show
    app_feedback text,
    app_created_date timestamp default current_timestamp,
    app_record_status varchar(1) not null default '0',
    id_client int not null,
    id_property int not null,
    id_agent int not null,
    id_appointment_type int not null,
    constraint fk1_data_appointment foreign key (id_client) references data.data_client (cli_id),
    constraint fk2_data_appointment foreign key (id_property) references data.data_property (pro_id),
    constraint fk3_data_appointment foreign key (id_agent) references data.data_agent (age_id),
    constraint fk4_data_appointment foreign key (id_appointment_type) references data.data_appointment_type (apt_id)
  );

create index idx_appointment_client on data.data_appointment (id_client);

create index idx_appointment_property on data.data_appointment (id_property);

create index idx_appointment_agent on data.data_appointment (id_agent);

create index idx_appointment_date on data.data_appointment (app_date);

-- 6. CONTRATOS Y TRANSACCIONES
-- ================================================
create table
  data.data_contract_type (
    cty_id serial primary key,
    cty_name varchar(50) not null, -- venta, alquiler, administración
    cty_description varchar(200),
    cty_created_date timestamp default current_timestamp,
    cty_record_status varchar(1) not null default '0'
  );

create table
  data.data_contract (
    con_id serial primary key,
    con_number varchar(50) not null,
    con_start_date date not null,
    con_end_date date,
    con_total_amount numeric(12, 2) not null,
    con_commission_amount numeric(10, 2),
    con_deposit_amount numeric(10, 2),
    con_monthly_rent numeric(10, 2), -- para alquileres
    con_payment_day int, -- día del mes para pagos de alquiler
    con_terms_conditions text,
    con_signed_date date,
    con_document_url varchar(300),
    con_status varchar(20) default 'draft', -- draft, active, completed, cancelled
    con_created_date timestamp default current_timestamp,
    con_record_status varchar(1) not null default '0',
    id_property int not null,
    id_client int not null,
    id_owner int not null, -- propietario
    id_agent int not null,
    id_contract_type int not null,
    id_real_estate_agency int not null,
    constraint fk1_data_contract foreign key (id_property) references data.data_property (pro_id),
    constraint fk2_data_contract foreign key (id_client) references data.data_client (cli_id),
    constraint fk3_data_contract foreign key (id_owner) references data.data_person (per_id),
    constraint fk4_data_contract foreign key (id_agent) references data.data_agent (age_id),
    constraint fk5_data_contract foreign key (id_contract_type) references data.data_contract_type (cty_id),
    constraint fk6_data_contract foreign key (id_real_estate_agency) references data.data_real_estate_agency (rea_id)
  );

create index idx_contract_property on data.data_contract (id_property);

create index idx_contract_client on data.data_contract (id_client);

create index idx_contract_agent on data.data_contract (id_agent);

create index idx_contract_status on data.data_contract (con_status);

create index idx_contract_dates on data.data_contract (con_start_date, con_end_date);

-- 7. PAGOS Y FACTURACIÓN
-- ================================================
create table
  data.data_payment_concept (
    pco_id serial primary key,
    pco_name varchar(100) not null, -- alquiler, depósito, comisión, mantenimiento
    pco_description varchar(200),
    pco_created_date timestamp default current_timestamp,
    pco_record_status varchar(1) not null default '0'
  );

create table
  data.data_payment_method (
    pam_id serial primary key,
    pam_name varchar(100) not null,
    pam_description varchar(200),
    pam_is_cash boolean default false,
    pam_created_date timestamp default current_timestamp,
    pam_record_status varchar(1) not null default '0'
  );

create table
  data.data_payment (
    pay_id serial primary key,
    pay_amount numeric(10, 2) not null,
    pay_due_date date,
    pay_paid_date date,
    pay_reference varchar(100),
    pay_notes text,
    pay_status varchar(20) default 'pending', -- pending, paid, overdue, cancelled
    pay_created_date timestamp default current_timestamp,
    pay_record_status varchar(1) not null default '0',
    id_contract int not null,
    id_payment_concept int not null,
    id_payment_method int,
    constraint fk1_data_payment foreign key (id_contract) references data.data_contract (con_id),
    constraint fk2_data_payment foreign key (id_payment_concept) references data.data_payment_concept (pco_id),
    constraint fk3_data_payment foreign key (id_payment_method) references data.data_payment_method (pam_id)
  );

create index idx_payment_contract on data.data_payment (id_contract);

create index idx_payment_status on data.data_payment (pay_status);

create index idx_payment_dates on data.data_payment (pay_due_date, pay_paid_date);

-- 8. DOCUMENTOS Y REPORTES
-- ================================================
create table
  data.data_document_type (
    dty_id serial primary key,
    dty_name varchar(100) not null, -- escritura, planos, permisos, facturas
    dty_description varchar(200),
    dty_created_date timestamp default current_timestamp,
    dty_record_status varchar(1) not null default '0'
  );

create table
  data.data_document (
    doc_id serial primary key,
    doc_name varchar(200) not null,
    doc_file_url varchar(300) not null,
    doc_file_size int,
    doc_mime_type varchar(100),
    doc_notes text,
    doc_created_date timestamp default current_timestamp,
    doc_record_status varchar(1) not null default '0',
    id_document_type int not null,
    id_property int,
    id_contract int,
    id_client int,
    constraint fk1_data_document foreign key (id_document_type) references data.data_document_type (dty_id),
    constraint fk2_data_document foreign key (id_property) references data.data_property (pro_id),
    constraint fk3_data_document foreign key (id_contract) references data.data_contract (con_id),
    constraint fk4_data_document foreign key (id_client) references data.data_client (cli_id)
  );

create index idx_document_type on data.data_document (id_document_type);

create index idx_document_property on data.data_document (id_property);

create index idx_document_contract on data.data_document (id_contract);

create index idx_document_client on data.data_document (id_client);