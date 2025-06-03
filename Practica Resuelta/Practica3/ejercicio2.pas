Program ejercicio2;
const
    valorAlto = '9999';
type
  asistente = record
    numAsistente: integer;
    dni: string[8];       
    nombre: string[30];    
    apellido: string[30];   
    edad: integer;          
    telefono: string[10];   
  end;

  archivo_asistentes = file of asistente;

    procedure leer(var arch: archivo_asistentes; var dato: asistente);
    begin
        if (not eof(arch)) then
            read(arch, dato)
        else
            dato.dni := valorAlto;
    end;

    procedure leerAsistente(var a: asistente);
    begin
        writeln('Ingrese número de asistente (0 para terminar): ');
        readln(a.numAsistente);
        
        if a.numAsistente <> 0 then begin
            writeln('Ingrese DNI: ');
            readln(a.dni);
            
            writeln('Ingrese nombre: ');
            readln(a.nombre);
            
            writeln('Ingrese apellido: ');
            readln(a.apellido);
            
            writeln('Ingrese edad: ');
            readln(a.edad);
            
            writeln('Ingrese teléfono: ');
            readln(a.telefono);
            end;
    end;


    procedure cargarArchivo (var arch: archivo_asistentes);
    var
        reg: asistente;
    begin   
        rewrite(arch);
        leerAsistente(reg);
        while (reg.numAsistente <> 0) do begin
            write(arch, reg);
            leerAsistente(reg);
        end;

        close(arch);
    end;

    procedure eliminarAsistentes (var arch: archivo_asistentes);
    var
        reg: asistente;
    begin
        reset(arch);

        leer(arch, reg);
        while (reg.dni <> valorAlto) do begin
            if (reg.numAsistente < 1000) then begin
                reg.nombre := '#' + reg.nombre;
                seek(arch, FilePos(arch) - 1);
                write(arch, reg);
            end;
            leer(arch, reg);
        end;

        close(arch);
    end;

var
    arch: archivo_asistentes;
begin
    assign(arch, 'archivo_asistentes');
    cargarArchivo(arch);
    eliminarAsistentes(arch);
end.