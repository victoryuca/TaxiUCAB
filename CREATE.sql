// Create de los TDA //

create or replace type DatosBasicos as object(
	nombre1 varchar2(60),
	nombre2 varchar2(60),
	apellido1 varchar2(60),
	apellido2 varchar2(60),
	email varchar2(60),
	fnac date,
	cedula varchar2(15)
);

create or replace type Telefono as object(
	numero varchar2(30),
	tipo varchar2(30)
);

create or replace type Ubicacion as object(
	latitud number,
	longitud number
);

// Create de las tablas //

create sequence id_pasajero minvalue 1 start with 1 increment by 1 nocache;
create table pasajero(
	id number not null primary key,
	datos DatosBasicos not null,
	telefono Telefono not null,
	tipo varchar2(11) not null,
	ubicacion Ubicacion,
	constraint tipo check(tipo IN('Natural', 'Corporativo'))
);

create sequence id_usuario minvalue 1 start with 1 increment by 1 nocache;
create table usuario(
	id number not null primary key,
	alias varchar2(30) not null,
	contraseña varchar2(30) not null,
	fk_pasajero number,
	fk_conductor number,
	constraint fk_pasajero foreign key(fk_pasajero) references pasajero(id)
);

create sequence id_marca minvalue 1 start with 1 increment by 1 nocache;
create table marca(
	id number not null primary key,
	nombre varchar2(30) not null
);

create sequence id_modelo minvalue 1 start with 1 increment by 1 nocache;
create table modelo(
	id number not null primary key,
	nombre varchar2(30) not null,
	year number(4),
	fk_marca number not null,
	constraint fk_marca foreign key(fk_marca) references marca(id)
);

create sequence id_vehiculo minvalue 1 start with 1 increment by 1 nocache;
create table vehiculo(
	id number not null primary key,
	color varchar2(10) not null,
	placa varchar(7) not null,
	aire_acondicionado varchar2(2) not null,
	reproductor varchar2(2) not null,
	blindado varchar2(2) not null,
	fk_modelo number not null,
	constraint fk_modelo foreign key(fk_modelo) references modelo(id),
	constraint aire_acondicionado check(aire_acondicionado IN('Si', 'No')),
	constraint reproductor check(reproductor IN('Si', 'No')),
	constraint blindado check(blindado IN('Si', 'No'))
);

create sequence id_conductor minvalue 1 start with 1 increment by 1 nocache;
create table conductor(
	id number not null primary key,
	datos DatosBasicos not null,
	telefono Telefono not null,
	ubicacion Ubicacion,
	fk_vehiculo number not null,
	constraint fk_vehiculo foreign key(fk_vehiculo) references vehiculo(id)
);

create sequence id_pas_con minvalue 1 start with 1 increment by 1 nocache;
create table pas_con(
	id number not null primary key,
	fk_pasajero number not null,
	fk_conductor number not null,
	constraint fk_pasajero1 foreign key(fk_pasajero) references pasajero(id),
	constraint fk_conductor1 foreign key(fk_conductor) references conductor(id)
);

create sequence id_cuenta_banco minvalue 1 start with 1 increment by 1 nocache;
create table cuenta_banco(
	id number not null primary key,
	numero number not null,
	tipo varchar2(9) not null,
	banco varchar2(30) not null,
	fk_conductor number not null,
	constraint tipo1 check(tipo IN('Corriente', 'Ahorro')),
	constraint fk_conductor2 foreign key(fk_conductor) references conductor(id)
);

create sequence id_lugar minvalue 1 start with 1 increment by 1 nocache;
create table lugar(
	id number not null primary key,
	nombre varchar2(30) not null,
	tipo varchar2(30) not null,
	fk_lugar number not null,
	constraint fk_lugar foreign key(fk_lugar) references lugar(id)
);

create sequence id_servicio minvalue 1 start with 1 increment by 1 nocache;
create table servicio(
	id number not null primary key,
	punto_referencia varchar2(30) not null,
	monto_total number not null,
	fecha_requerida date not null,
	estatus varchar2(20) not null,
	codigo_pago number not null,
	fecha_servicio date not null,
	fk_lugar_origen number not null,
	fk_lugar_destino number not null,
	fk_conductor number not null,
	fk_pasajero number not null,
	constraint fk_lugar_origen foreign key(fk_lugar_origen) references lugar(id),
	constraint fk_lugar_destino foreign key(fk_lugar_destino) references lugar(id),
	constraint fk_conductor3 foreign key(fk_conductor) references conductor(id),
	constraint fk_pasajero3 foreign key(fk_pasajero) references pasajero(id)
);

create sequence id_metodo_pago minvalue 1 start with 1 increment by 1 nocache;
create table metodo_pago(
	id number not null primary key,
	num_billetes number,
	denominacion varchar(10),
	codigo_seguridad number(3),
	banco varchar2(30),
	num_tarjeta number(16),
	tipo varchar2(10),
	fecha_vencimiento date,
	saldo number,
	fk_pasajero number not null,
	constraint tipo2 check(tipo IN('Visa', 'MasterCard')),
	constraint fk_pasajero4 foreign key(fk_pasajero) references pasajero(id)
);

create sequence id_pago minvalue 1 start with 1 increment by 1 nocache;
create table pago(
	id number not null primary key,
	monto number not null,
	fecha_pago date not null,
	fk_metodo_pago number not null,
	fk_servicio number not null,
	constraint fk_metodo_pago foreign key(fk_metodo_pago) references metodo_pago(id),
	constraint fk_servicio foreign key(fk_servicio) references servicio(id)
);

create sequence id_inspeccion minvalue 1 start with 1 increment by 1 nocache;
create table inspeccion(
	id number not null primary key,
	fecha_cita number not null,
	elegible varchar2(2) not null,
	comentario varchar2(60) not null,
	hora_cita varchar2(5) not null,
	fk_vehiculo number not null,
	constraint elegible check(elegible IN('Si', 'No')),
	constraint fk_vehiculo2 foreign key(fk_vehiculo) references vehiculo(id)
);

create sequence id_pas_mon minvalue 1 start with 1 increment by 1 nocache;
create table pas_mon(
	id number not null primary key,
	fk_pasajero number not null,
	fk_monedero number not null,
	constraint fk_pasajero5 foreign key(fk_pasajero) references pasajero(id),
	constraint fk_metodo_pago1 foreign key(fk_monedero) references metodo_pago(id)
);

create sequence id_calificacion minvalue 1 start with 1 increment by 1 nocache;
create table calificacion(
	id number not null primary key,
	conductor number not null,
	pasajero number not null,
	fk_servicio number not null,
	constraint fk_servicio1 foreign key(fk_servicio) references servicio(id)
);