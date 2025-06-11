program PrimerFecha2025;
const
    valorAlto = '9999';
type
    str4 = String[4];
    presentacion = record   
        anio: str4;
        codArtista, codEvento, likes, dislikes, puntaje: integer;
        nombreArtista, nombreEvento: String;
    end;

    archivo = file of presentacion;

procedure leer(var arch: archivo; var p: presentacion);
begin
    if not eof(arch) then   
        read(arch, p)
    else 
        p.anio := valorAlto;
end;

procedure minimo (puntajeTotal, dislikes: integer; nombreArtista: String; var puntajeMin, dislikesMax: integer; var nombreMin: String);
 begin
    if (puntajeTotal < puntajeMin) then begin
        puntajeMin:= puntajeTotal;
        nombreMin:= nombreArtista;
    end
    else 
        if (puntajeTotal = puntajeMin) then
            if (dislikes > dislikesMax) then begin
                puntajeMin:= puntajeTotal;
                nombreMin:= nombreArtista;
                dislikesMax:= dislikes; // me lo olvide poner :(
            end;
 end;

procedure generarInforme (var arch: archivo);
var
    anio: str4;
    p: presentacion;
    codEvento, codArtista, totalLikes, totalDislikes, puntajeTotal, puntajeMin, dislikesMax, cantPresentaciones, totalPresentaciones, cantAnios: integer;
    nombreEvento, nombreArtista, nombreMin: String;

begin
    reset(arch);
    leer(arch, p);
    totalPresentaciones := 0;
    cantAnios:= 0;
    writeln('Resumen de menor influencia por evento');

    while(p.anio <> valorAlto) do begin
        anio:= p.anio;
        cantPresentaciones:= 0;
        cantAnios:= cantAnios + 1;
        writeln('Anio:', anio);

        while(p.anio = anio) do begin
            codEvento:= p.codEvento;
            nombreEvento:= p.nombreEvento;
            puntajeMin:= 9999; 
            dislikesMax:= -1; // me confundi y puse dislikes min inicializada en valor 9999
            writeln('Evento: ', nombreEvento, ' Codigo: ', codEvento);

            while(p.anio = anio) and (p.codEvento = codEvento) do begin
                codArtista:= p.codArtista;
                nombreArtista:= p.nombreArtista;
                totalLikes:=0; totalDislikes:=0; puntajeTotal:=0;
                writeln('Artista: ', nombreArtista, ' Codigo ', codArtista);

                while(p.anio = anio) and (p.codEvento = codEvento) and (p.codArtista = codArtista) do begin
                    totalLikes := totalLikes + p.likes;
                    totalDislikes := totalDislikes + p.dislikes;
                    puntajeTotal:= puntajeTotal + p.puntaje;
                    cantPresentaciones := cantPresentaciones + 1;
                    leer(arch, p);
                end;
                writeln('Likes totales: ', totalLikes);
                writelN('Dislikes totales: ', totalDislikes);
                writeln('Diferencia: ', (totalLikes - totalDislikes));
                writeln('Puntaje total del jurado: ', puntajeTotal);
                minimo(puntajeTotal, totalDislikes,nombreArtista, puntajeMin,dislikesMax, nombreMin);
            end;
            writeln('El artista ', nombreMin, ' fue el artista menos influyente de ', nombreEvento, ' del anio ', anio);

        end;
        writeln('Durante el anio ', anio, ' se registraron ', cantPresentaciones, ' de artistas');
        totalPresentaciones := totalPresentaciones + cantPresentaciones;

    end;
    writeln('El promedio total de presentaciones por anio es de ', cantAnios/totalPresentaciones:0:1, ' presentaciones');
    close(arch);
end;

var
    arch: archivo;
begin
    assign(arch, 'archivo');
    generarInforme(arch);
end.