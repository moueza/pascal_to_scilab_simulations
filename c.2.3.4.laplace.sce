
function  laplace()
    //angl1AzimutDeg
    xmaxi =40;//dim du reseau de points
    ymini=-25
    ymaxi=10
    vmaxi=100;//potentiel max
    nbcourbe=20;//nb d equipotentielles a tracer
    pas=.1;//finesse du trace
    erreurmax=.1 ;//precision d arret
    v;
    diffmax;//variation max du potentiel
endfunction




function initialise()
    /*affecte au potentiel une valeur de 0...*/
    i;j;
    valeur;
    for j=ymini:0
        for i=-1:xmaxi
            v(i,j)=0
        end
    end

    for j=1:ymaxi
        valeur=j*vmaxi/ymaxi
        for i=-1:xmaxi
            v(i,j)=valeur
        end
    end
endfunction


function moyenne(i,j)
    aux=v(i,j)

    v(i,j)=(v(i-1,j)+v(i+1,j)+v(i,j-1)+v(i,j+1))/4
    if (v(i,j)>1e-6) 
        then
        delta=abs((aux-v(i,j))/v(i,j) )
    else 
        delta=5
    end

    if (delta>diffmax) 
        then
        diffmax=delta
    end
endfunction



function calcule()
    /***/
    i;j;
    aux;delta;

    diffmax=0
    for j=1:ymaxi-1
        for j=0:xmaxi-1
            moyenne(i,j)     
        end
    end

    for i=0:(xmaxi div 3)-1
        moyenne(i,0)
    end

    for j=ymini+1:-1
        for i=0:xmaxi-1
            moyenne(i,j)
        end
    end

    for j=ymini+1:ymaxi-1
        v(-1,j)=v(1,j)
    end
endfunction

function [y]=absc(x)
   y= rnd(xmax*(1+x/xmaxi)/2)
    
endfunction
