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

--t1
INSERT INTO reservas (idReserva, idFuncion, idCliente, fecha, estado) VALUES (3, 1, 87654321, TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'Reserva'); --Cliente 1
--t2
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion) VALUES (3, 'S1', 1); --Cliente 1
select idReserva from SillasReservas where idSilla = 'S1' and idFuncion = 1; --Cliente 1
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion) VALUES (3, 'S2', 1); --Cliente 2
select idReserva from SillasReservas where idSilla = 'S2' and idFuncion = 2; --Cliente 2
 -- ReservarSillas – idS1 Select * from sillasreservas

DROP TABLE RESERVAS CASCADE CONSTRAINTS;
DROP TABLE SILLASRESERVAS CASCADE CONSTRAINTS;

--CLIENTE 1
-- t1: Operación 1 - Crear reserva
INSERT INTO reservas (idReserva, idFuncion, idCliente, fecha, estado) 
VALUES (1, 1, 12345678, SYSDATE, 'Reserva');

-- t2: InserciónA - Reservar S1
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion) 
VALUES (1, 'S1', 1);

-- t3: InserciónB - Intentar reservar S2 (esperará porque Sesión 2 la tiene bloqueada)
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion) 
VALUES (1, 'S2', 1);


--CLIENTE 2
-- t1: Operación 1 - Crear reserva  
INSERT INTO reservas (idReserva, idFuncion, idCliente, fecha, estado)
VALUES (2, 1, 87654321, SYSDATE, 'Reserva');
COMMIT;

-- t3: InserciónA - Reservar S2
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion)
VALUES (2, 'S2', 1);
select * from SillasReservas;

-- t5: InserciónB - Intentar reservar S1 (¡DEADLOCK! - Sesión 1 la tiene bloqueada)
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion)
VALUES (2, 'S1', 1);
COMMIT;
ROLLBACK;



-- t1: Actualizar
INSERT INTO SillasReservas (idReserva, idSilla, idFuncion) 
VALUES (3, 'S1', 1);

UPDATE SillasReservas 
SET idReserva = 6
WHERE idSilla = 'S1' AND idFuncion = 1;

-- t3: Confirmar
COMMIT;

-- t5: Segunda actualización  
UPDATE SillasReservas 
SET idReserva = 3 
WHERE idSilla = 'S1' AND idFuncion = 1;


-- t2: Primera consulta
SELECT * FROM SillasReservas WHERE idSilla = 'S1';

-- t4: Segunda consulta (después del commit)
SELECT * FROM SillasReservas WHERE idSilla = 'S1';

-- t6: Tercera consulta
SELECT * FROM SillasReservas WHERE idSilla = 'S1';