program parcial;

type
	vClase = array [1 .. 12] of boolean;
	
	alumno = record
		dni: integer;
		nombre, apellido: string;
		nota : real;
		turno : integer;
		clase : vClase;
	end;
	
	lista = ^nodo;
	
	nodo = record
		dato: alumno;
		sig: lista;
	end;
	
	vContadorTurno = array [1.. 4] of integer;
	
procedure iniVContador(var vCT: vContadorTurno); //Muy importante inicializar el vector contador, por peligro de que haya basura.
	var
		i:integer;
	begin
		for i:= 1 to 4 do
			vCT[i] := 0;
	end;
	
procedure leer(var a:alumno);
	var
		i:integer;
		respuesta: string;
	begin
		writeln('Ingrese el dni del alumno: ');
		readln(a.dni);
		if(a.dni <> 0)then
			begin
				writeln('Ingrese el nombre del alumno: ');
				readln(a.nombre);
				writeln('Ingrese el apellido del alumno: ');
				readln(a.apellido);
				writeln('Ingrese la nota del alumno: ');
				readln(a.nota);
				writeln('Ingrese el turno del alumno: ');
				readln(a.turno);
				writeln('Ingrese para cada dia de la practica, si asistio o no.');
				for i:= 1 to 12 do
					begin
						writeln('DIA: ', i);
						writeln('"si" si asisitio, "no" en caso contrario: '); //ingresar si o no, no sean bobis
						readln(respuesta);
						if(respuesta = 'si')then
							a.clase[i] := true
						else
							a.clase[i] := false;
					end;
			end;
		
	end;

procedure agregarAdelante(var l:lista; d:alumno);
	var
		nue:lista;
	begin
		new(nue);
		nue^.dato := d;
		nue^.sig:= l;
		l:= nue;
	end;

procedure agregarDatos(var l:lista); 
	var
		a: alumno;
	begin
		leer(a);
		while(a.dni <> 0)do
			begin
				agregarAdelante(l, a);
				leer(a);
			end;
	end;

procedure nuevaLista (lAlumnos: lista; var nueLista: lista);
	var
		a:alumno;
		i, contAsistio:integer;
	begin
		while(lAlumnos <> nil) do
			begin
				contAsistio:= 0;
				a:= lAlumnos^.dato;
				i:= 1;
				while (contAsistio < 8) and (i <= 12) do // solo necesito saber si asistio a 8 clases, si lo hizo, nice, caso contrario, a seguir contando.
					begin
						if(a.clase[i] = true)then
							contAsistio:= contAsistio + 1;
						i := i + 1;
					end;
				if(contAsistio >= 8)then
					agregarAdelante(nueLista, a);
				lAlumnos:= lAlumnos^.sig;
			end;
	end;

function nota8 (nota : real): boolean;
	var
		ok:boolean;
	begin
		ok:= false;
		if(nota >= 8)then
			ok:= true;
		nota8:= ok;
	end;

procedure turnoMax (vCT:vContadorTurno);
	var
		max, tMax, i:integer;
	begin
		max:= 0;
		for i:= 1 to 4 do		
			if(vCT[i] > max)then
				begin
					max:= vCT[i];
					tMax:= i;
				end;
		writeln('El turno', tMax, ' tuvo mas alumnos: ', max);
	end;
	
function dniConCero (dni: integer): boolean;
	var
		digito, dniDescompuesto: integer;
		ok:boolean;
	begin
		ok:= false;
		dniDescompuesto:= -1;
		digito := dni mod 10;
		while ((dniDescompuesto <> 0) and (digito <> 0)) do //si dniDescompuesto se pone en 0, es porque ya no se puede dividir por 10, y si el digito se pone en 0, significa que ya hay un 0 en el dni
			begin
				dniDescompuesto:= dni div 10;
				digito := dni mod 10;
			end;
		if(digito = 0) then
			ok:= true;
		dniConCero:= ok;
	end;
	
procedure recorrerLista (nueLista: lista); //recordar que aca estan solo los alumnos que tienen al menos 8 asistidas en las practicas.
	var
		vCT: vContadorTurno;
		alumnosDniSinCero: integer;
	begin
		alumnosDniSinCero:= 0;
		iniVContador(vCT);
		while(nueLista <> nil)do
			begin
				if(nota8(nueLista^.dato.nota))then
					writeln('El alumno con dni: ', nueLista^.dato.dni, '. Nombre: ', nueLista^.dato.nombre, ' y apellido: ', nueLista^.dato.apellido, ' aprobo con nota mayor que 8.');
				vCT[nueLista^.dato.turno] := vCT[nueLista^.dato.turno] + 1; //sumo uno al turno que que corresponda el alumno.
				if(not dniConCero(nueLista^.dato.dni))then
					alumnosDniSinCero:= alumnosDniSinCero + 1;
				nueLista:= nueLista^.sig;
			end;
		turnoMax(vCT);
		writeln('La cantidad de alumnos sin cero en su dni son: ', alumnosDniSinCero);
	end;
	
var
	lAlumnos, lNueva : lista;
begin
	agregarDatos(lAlumnos);
	nuevaLista(lAlumnos, lNueva);
	recorrerLista(lNueva);
end.
