program ejercicio7;
const
    valorAlto= '9999';
type
    str4 = String[4];
    str20 = String[20];

    ave = record
        cod: str4;
        nombre: str20;
        familia: str20;
        descripcion: str20;
        zona: str20;
    end;

    archivo_aves = file of ave;

    procedure leer(var arch: archivo_aves; var dato: ave);
    begin
        if not eof(arch) then
            read(arch, dato)
        else
            dato.cod:= valorAlto;
    end;

    procedure eliminarAve(var arch: archivo_aves);
    var
        reg: ave;
        cod: str4;
        encontre: boolean;
    begin
        reset(arch);
        writeln('Ingrese codigo del ave a eliminar');
        readln(cod);
        encontre := false;

        leer(arch, reg);
        while (reg.cod <> valorAlto) and not (encontre) do begin
            if (reg.cod = cod) then 
                encontre := true
            else
                 leer(arch, reg);
        end;

        if (encontre) then begin
            reg.nombre := '#' + reg.nombre;
            seek(arch, FilePos(arch) - 1);
            write(arch, reg);
            writeln('Se ha eliminado con exito');
        end
        else 
            writeln('No se ha encontrado el codigo de ave ingresado');

        close(arch);        
    end;

    procedure compactar (var arch: archivo_aves);
    var
        reg, reg_ultimo: ave;
        pos: integer;
    begin
        reset(arch);

        while not eof(arch) do begin
            read(arch, reg);
            if (reg.nombre[1] = '#') then begin
                //Me guardo la posicion libre
                pos := FilePos(arch) - 1;

                //Leo el ultimo registro 
                seek(arch, FileSize(arch) - 1);
                read(arch, reg_ultimo);

                //Escribo el registro a eliminar en la ultima posicion
                seek(arch, FileSize(arch) - 1);
                write(arch, reg);

                //Elimino el ultimo registro para evitar duplicados
                seek(arch, FileSize(arch) - 1);
                truncate(arch);

                //Escibro el registro que estaba al final en la posicion libre
                seek(arch, pos);
                write(arch, reg_ultimo);

                //Vuelvo a la posicion donde estaba para no saltearme ningun registro
                seek(arch, FilePos(arch) - 1)
            end;
        end;
        writeln('Se ha compactado el archivo correctamente');
        close(arch);
    end;

    procedure compactarMejorado (var arch: archivo_aves);
    var
        reg: ave;
        posActual, posUltimo: integer;
        regUltimo: ave;
    begin
        reset(arch);
        posActual := 0;
        posUltimo := FileSize(arch) - 1;

        while posActual <= posUltimo do begin
            seek(arch, posActual);
            read(arch, reg);

            if (reg.nombre[1] = '#') then begin
                // Guardo el ultimo registro
                seek(arch, posUltimo);
                read(arch, regUltimo);

                // Escribo el ultimo registro en la posicion actual (la que quiero eliminar)
                seek(arch, posActual);
                write(arch, regUltimo);

                // Actualizo el nuevo tope (ya que el último se movio)
                posUltimo := posUltimo - 1;
            end
            else
                posActual := posActual + 1;
        end;

        // Trunco una sola vez: elimino todos los registros que quedaron "de mas" al final
        seek(arch, posUltimo + 1);
        truncate(arch);

        writeln('Archivo compactado exitosamente.');
        close(arch);
    end;


var
    arch: archivo_aves;
    opcion: byte;
begin
    assign(arch,'archivo_aves');
    repeat
        writeln('Ingrese la opcion deseada');
        writeln('1. Eliminar ave');
        writeln('2. Compactar archivo');
        writeln('3. Compactar archivo con un trunque');
        writeln('4. Salir');
        readln(opcion);

        case opcion of
            1: eliminarAve(arch);
            2: compactar(arch);
            3: compactarMejorado(arch);
        end;
    until (opcion = 4);
end.