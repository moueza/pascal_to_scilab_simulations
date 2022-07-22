//angl1AzimutDeg
xmaxi =40;//dim du reseau de points
ymini=-25
ymaxi=10
vmaxi=100;//potentiel max
nbcourbe=20;//nb d equipotentielles a tracer
pas=.1;//finesse du trace
erreurmax=.1 ;//precision d arret
// v;
// diffmax;//variation max du potentiel
global v



function initialisee()
    /*affecte au potentiel une valeur de 0...*/
 //   i;j;
   // valeur;
    for j=ymini:0
        for i=-1:xmaxi
            v(i,j)=0;
        end
    end

    for j=1:ymaxi
        valeur=j*vmaxi/ymaxi;
        for i=-1:xmaxi
            v(i,j)=valeur;
        end
    end
endfunction


function moyenne(i,j)
    global aux
    aux=v(i,j)

    v(i,j)=(v(i-1,j)+v(i+1,j)+v(i,j-1)+v(i,j+1))/4
    if (v(i,j)>1e-6)        then
        delta=abs((aux-v(i,j))/v(i,j) );
    else 
        delta=5;
    end

    if (delta>diffmax) then
        diffmax=delta;
    end
endfunction



function calcule()
    /***/
    //  i;j;
    //  aux;delta;

    diffmax=0
    for j=1:ymaxi-1
        for i=0:xmaxi-1
            moyenne(i,j);     
        end
    end

    // for i=0:(xmaxi div 3)-1
    for i=0:(int(xmaxi/3))-1
        moyenne(i,0);
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
    y= round(xmaxi*(1+x/xmaxi)/2)

endfunction

function res=ordo(y)
    exec('D:\POUB\pascal_to_scilab_simulations\c.2.3.4.laplace.sce', -1)

    res=ymaxi-round((y-ymini)*ymaxi/(ymaxi-ymini))
endfunction








function tracee(a,b,c,d,e)
    //clf();
    exec('D:\POUB\pascal_to_scilab_simulations\c.2.3.4.laplace.sce', -1)

    //x=[0:0.1:2*%pi]';
    x=[absc(a),absc(c)]
    y=[ordo(b),ordo(d)]
    x
    y
    plot2d(x,y);

    x=[absc(-a),absc(-c)]
    y=[ordo(b),ordo(d)]
    x
    y
    plot2d(x,y);
endfunction



function equipotboucl()
    i=int(x)
    j=int(y)
    dx=v(i,j)-v(i-1,j)
    dy=v(i,j)-v(i,j-1)
    d=sqrt(dx*dx+dy*dy)
    dx=dx*pas/d
    dy=dy*pas/d 
    tracee(x,y,x-dy,y+dx,2)
    x=x-dy
    y=y+dx   
endfunction 

function equipot(t)
    x=xmaxi
    y=ymaxi*t

    equipotboucl()
    while(x<=0),
        equipotboucl()
    end

endfunction





function dessine()
    exec('D:\POUB\pascal_to_scilab_simulations\c.2.3.4.laplace.sce', -1)

    tracee(xmaxi,ymini,xmaxi,ymaxi,1)
    tracee(int(xmaxi/3),0,xmaxi,0,1)
    tracee(0,ymini,xmaxi,ymaxi,1)
    tracee(0,ymaxi,xmaxi,ymaxi,1)
    for i=1:nbcourbe,
        equipot((i-.5)/nbcourbe);
    end
endfunction

function calwrit()
    calcule()
    //:4
    round(100*diffmax)
endfunction

initialisee()
//idem do while
calwrit()
while diffmax<erreurmax
    calwrit() ; 
end
