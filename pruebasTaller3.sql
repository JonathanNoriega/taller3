create table Reservas
(
 idReserva number(5)
 constraint pk_reservas
primary key,
 idFuncion number(3),
 idCliente number(8),
 fecha date,
 estado varchar(8)
 constraint ck_r_estado
check (estado IN
('Reserva','Compra'))
);
create table SillasReservas
(
 idSilla varchar(3),
 idFuncion number(3),
 idReserva number(5) not null
constraint fk_sr_reservas
references Reservas,
 constraint pk_sillasReservas
primary key (idSilla,
idFuncion)
);
DROP TABLE RESERVAS CASCADE CONSTRAINTS; 



Select * from reservas; --Cliente 1
--Ningun problema al ejecutar
Select * from reservas; --Cliente 2

SET AUTOCOMMIT ON; --Cliente 1

INSERT INTO RESERVAS (idReserva, idFuncion, idCliente, fecha, estado) VALUES (1, 1, 12345678, TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'Reserva'); --Cliente 1

SELECT * FROM RESERVAS; --Cliente 1



SET AUTOCOMMIT OFF;
BEGIN TRANSACTION;

INSERT INTO Reservas (id_reserva, id_cliente, id_funcion, fecha_reserva)
VALUES (id_reserva_param, id_cliente_param, id_funcion_param, SYSDATE);


INSERT INTO SillasReservas (id_reserva, id_silla, fecha_creacion)
VALUES (id_reserva_param, id_silla_1_param, SYSDATE);

 
INSERT INTO SillasReservas (id_reserva, id_silla, fecha_creacion)
VALUES (id_reserva_param, id_silla_2_param, SYSDATE);

END;
COMMIT;

 