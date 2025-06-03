Program Ejercicio11;
const 
    valorAlto = '9999';
    cantCategorias = 15;
type
    rangoCategoria = 1..cantCategorias;
    empleado = record
        depto: String [4];
        division: integer;
        numEmpleado: integer;
        categoria: integer
        horasExtras: integer;
    end;

    vectorValoresHora = array [rangoCategoria] of real;
    maestro = file of empleado;


    procedure leer (var mae: maestro, var dato: empleado);
    begin
        if not EOF(mae) then
            read(mae, dato)
        else 
            dato.depto := valorAlto;    
    end;

    procedure cargarVector(var arch: txt, var valoresHora: vectorValoresHora);
    var
        i: integer;
        valor: real;
    begin
        reset(arch);
        for i := 1 to cantCategorias do begin
            readln(arch, valor);
            valoresHora[i] := valor;
        end;
        close(arch);
    end;


    procedure informar (var mae: maestro, valoresHora: vectorValoresHora);
    var
        depto: String[4];
        regMae: empleado;
        horasEmpleado, horasDivision, 
        horasDepto, division, numEmpleado, categoria: integer;
        importeEmpleado, importeDivision, importeDepto,: real;
    begin
        reset(mae);
        leer(mae, regMae);
        
        while (regMae.depto <> valorAlto) do begin
            depto:= regMae.depto;
            horasDepto:= 0;
            importeDepto:= 0;
            writeln('---------------------------')
            writeln ('Departamento: ', depto);

            while (depto = regMae.depto) do begin
                division := regMae.division;
                horasDivision := 0;
                importeDivision := 0;
                writeln('Division: ', division);

                while (depto = regMae.depto) and (division = regMae.division) do begin
                    numEmpleado := regMae.numEmpleado;
                    categoria := regMae.categoria;
                    horasEmpleado := 0;
                    importeEmpleado:= 0;

                    while (depto = regMae.depto) and (division = regMae.division) and (numEmpleado = regMae.numEmpleado) do begin
                        horasEmpleado := horasEmpleado + regMae.horasExtras;
                        leer(mae, regMae);
                    end;
            
                    importeEmpleado := importeEmpleado + (horasEmpleado * valoresHora[categoria]);
                    writeln('Numero de Empleado: ', numEmpleado, ' Total de horas: ', horasEmpleado, ' Importe a cobrar: $', importeEmpleado:0:2);
                end;

                horasDivision := horasDivision + horasEmpleado;
                importeDivision := importeDivision + importeEmpleado;
                writeln('Total de horas de la division: ', horasDivision);
                writeln('Monto total de la division: $', importeDivision:0:2);
            end;
            
            horasDepto := horasDepto + horasDivision;
            importeDepto := importeDepto + importeDivision;
            writeln('Total horas del departamento:', horasDepto);
            writeln('Monto total del departamento: $', importeDepto:0:2);
        end;

        close(mae);
    end;

var
    archValoresHora: txt;
    mae: maestro;
    valoresHora: vectorValoresHora;
begin
    assign(mae, 'archivo_maestro');
    assign(archValoresHora, 'archivo_valores');
    cargarVector(archValoresHora, valoresHora);
    informar(mae, valoresHora);
end.