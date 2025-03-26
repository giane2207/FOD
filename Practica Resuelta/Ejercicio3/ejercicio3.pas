program ejercicio3;
type 
    empleadoRegistro = record
        numEmpleado: integer;
        nombre: String;
        apellido: String;
        edad: integer;
        dni: integer;
    end;

    archivo_empleados = file of empleadoRegistro;

    procedure leer(var p: empleadoRegistro);
    begin
        writeln('Ingrese apellido: '); readln(p.apellido);
        if (p.apellido <> 'fin') then begin
            writeln('Ingrese nombre: '); readln(p.nombre);
            writeln('Ingrese numero de empleado: '); readln(p.numEmpleado);
            writeln('Ingrese edad: '); readln(p.edad);
            writeln('Ingrese dni: '); readln(p.dni);
       end;
    end;

    procedure cargarArchivo (var empleados: archivo_empleados);
    var 
         e: empleadoRegistro;
    begin
        rewrite(empleados);
         leer(e);
         while (e.apellido <> 'fin') do begin
            write(empleados, e);
            leer(e);
         end;
         close(empleados);
    end;

    procedure imprimirEmpleado (emp: empleadoRegistro);
    begin
         WriteLn('Numero de Empleado: ', emp.numEmpleado);
         WriteLn('Nombre: ', emp.nombre);
         WriteLn('Apellido: ', emp.apellido);
         WriteLn('Edad: ', emp.edad);
         WriteLn('DNI: ', emp.dni);
         WriteLn('--------------------------');
    end;

    procedure imprimirEmpleados (var empleados: archivo_empleados);
    var 
        emp: empleadoRegistro;
    begin
        reset(empleados);
        while (not EOF(empleados)) do begin
            read(empleados, emp);
            imprimirEmpleado(emp);
        end;
        close(empleados);
    end;

    function cumple(emp: empleadoRegistro; nombre: String): boolean;
    begin
        cumple:= (emp.nombre = nombre) or (emp.apellido = nombre);
    end;

    procedure imprimirEmpleadosDeterminados (var empleados: archivo_empleados);
    var
        nombre: String;
        emp: empleadoRegistro;
    begin
         reset(empleados);
         writeln('Ingrese nombre o apellido del empleado a buscar: '); 
         Readln(nombre);
         writeln ('Los empleados que tienen el nombre u apellido ', nombre, ' son: ');
         while (not EOF(empleados)) do begin
             read(empleados, emp);
             if (cumple(emp, nombre)) then
                 imprimirEmpleado(emp);
         end;
         close(empleados);
    end;

    procedure imprimirEmpleadosMas70 (var empleados: archivo_empleados);
    var 
        emp: empleadoRegistro;
    begin
      reset(empleados);
      writeln('Los empleados mayores de 70 anios son: ');
      while (not EOF(empleados)) do begin
         read(empleados, emp);
         if (emp.edad > 70) then
           imprimirEmpleado(emp);
      end;
      close(empleados);
    end;

    procedure abrirArchivo (var empleados: archivo_empleados);
    var 
        opcion: byte;
    begin
        //Se muestran las opciones disponibles 
        Writeln('Opciones para realizar con el archivo:');
        writeln('1. Mostrar todos los empleados.');
        writeln('2. Mostrar los empleados que tengan un nombre o apellido determinado.');
        writeln ('3. Mostrar los empleados mayores de 70 años, próximos a jubilarse.');
        writeln ('4. Salir.');
        writeln ('Seleccione una opcion:'); read(opcion);

        if (opcion <> 4) then
        begin
          case opcion of
             1: imprimirEmpleados(empleados);
             2: imprimirEmpleadosDeterminados(empleados);
             3: imprimirEmpleadosMas70(empleados);
            end;
        end;

    end;


var 
    empleados: archivo_empleados;
    p: empleadoRegistro;
    nombre_fisico: String[30];
    opcion: Byte;
begin
     //Se muestran las opciones disponibles y se lee una opcion
     writeln('Opciones:');
     writeln('1. Crear archivo de empleados');
     writeln('2. Abrir archivo de empleados');
     writeln('3. Salir');
     writeln('Ingrese el numero de operacion que desea realizar: ');
     readln(opcion);

     //Se solicita nombre fisico del archivo a crear o buscar
     if (opcion <> 3) then begin
             writeln('Ingrese nombre deseado para el archivo a crear o buscar:');
             readln(nombre_fisico);
             assign(empleados,nombre_fisico);
        end;

    //Se ejecuta la opcion seleccionada
     case opcion of
         1: cargarArchivo(empleados);
         2: abrirArchivo(empleados);
         3: writeln('Chau!');
     end;

end.