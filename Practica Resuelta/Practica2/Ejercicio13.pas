Program Ejercicio13;
const 
    valorAlto = '9999';
type
    infoMae = record 
        num: String[4];
        nombreUsuario: string;
        nomYape: String;
        cantMails: integer;        
    end;

    infoDet: record 
        num: String[4];
        destino: String;
        cuerpo: String;
    end;

    maestro = file of infoMae;
    detalle = file of infoDet;


    procedure leer (var det: detalle, var dato: infoDet);
    begin
        if not EOF(det) then
            read(det, dato)
        else 
            dato.num := valorAlto;    
    end;
    //----------------------------------------------------------------------
    //a
    procedure actualizarMaestro (var mae: maestro, det: detalle);
    var
      regMae: infoMae;
      regDet: infoDet;
      totalMails: integer;
      num: String[4];
    begin
        reset(mae);
        reset(det);

        leer(det, regDet);
        while(regDet.num <> valorAlto) do begin
            totalMails := 0;
            num := regDet.num;

            while (num = regDet.num) do begin
                totalMails := totalMails + 1;
                leer(det, regDet);
            end;
            
            read(mae, regMae);
            while (regMae.num <> num) do    
                read(mae, regMae);

            regMae.cantMails := regMae.cantMails + totalMails;
            seek(mae, filePos(mae) - 1);
            write(mae, regMae);

        end;

        close(mae);
        close(det);
    end;

    procedure generarInforme (var mae: maestro);
    var
        regMae: infoMae;
        archi: Text;
        num: String[4];
        cantMails: integer;
    begin
        reset(mae);
        assign(archi, 'archivo_informe');
        rewrite(archi);

        while (not eof(mae)) do begin
            read(mae, regMae);

            num := regMae.num;
            cantMails := regMae.cantMails;
            writeln(archi, 'numero de usuario: ', num, ' cantidad de mails: ', cantMails);
        end;

        close(mae);
        close(archi);
    end;

    //----------------------------------------------------------------------------------------

    //b
    procedure actualizarYgenerarInforme(var mae: maestro; var det: detalle);
    var
        regMae: infoMae;
        regDet: infoDet;
        txt: Text;
        totalMails: integer;
        numAct: String[4];
    begin
        reset(mae);
        reset(det);
        assign(txt, 'informe_diario.txt');
        rewrite(txt);

        leer(det, regDet);

        while not eof(mae) do begin
            read(mae, regMae);
            totalMails := 0;

            while regDet.num = regMae.num do begin
                totalMails := totalMails + 1;
                leer(det, regDet);
            end;

            regMae.cantMails := regMae.cantMails + totalMails;
            seek(mae, filePos(mae) - 1);
            write(mae, regMae);

            writeln(txt, 'numero de usuario: ', regMae.num, ' cantidad de mails: ', regMae.cantMails);
        end;

        close(mae);
        close(det);
        close(txt);
    end;
    

var
    mae: maestro;
    det: detalle;
begin
    assign(mae, '/var/log/logmail.dat');
    assign(det, 'archivo_detalle');

    //a
    actualizarMaestro(mae, det);
    generarInforme(mae);

    //b
    actualizarYgenerarInforme(mae,det);
end.