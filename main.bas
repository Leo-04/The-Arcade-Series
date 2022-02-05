print "loading, please wait"
print "...";
#include "fbgfx.bi"
Using FB
Screen 12, , , GFX_FULLSCREEN, 120
setmouse ,,0
Dim shared As Integer twid, w, h,res=8
#if __FB_LANG__ = "qb"
#define EXTCHAR Chr$(0)
#else
#define EXTCHAR Chr(255)
#endif

function rand(f as integer,t as integer) as integer
    dim as integer a
    
    a = cast(integer, fix(rnd*(t-f))+f)
    return a
end function

function getscores(file as string,scs() as long) as long
    open "scores/"&file for input as #1
    dim i as long = 0
    dim as string ln
    do until( eof(1) or (i=19) )
        line input #1, ln
        scs(i) = cast(long,ln)
        i+=1
    loop
    close #1
    return i
end function
sub replacescore(sc as long,scs() as long)
    dim i as long =0, ii as long = 0
    for i =0 to 20
        if scs(i)<sc then
            ii=19
            while ii<>i
                scs(ii) = scs(ii-1)
                ii-=1
            wend
            scs(i)=sc
            return
        end if
    next
    scs(19)=sc
    return
end sub
sub savescores(file as string,scs() as long)
    open "scores/"+file for output as #1
    dim i as long
    for i =0 to 20
        print #1,scs(i)
    next
    close #1
end sub





function getk() as string
    dim k as string = ""
    'sleep
    k=inkey
    while inkey<>""
    wend
    Select Case k


        Case Chr(32): return " "

        Case Chr(27): return "esc"

        Case EXTCHAR & "G": return "home"
        Case EXTCHAR & "H": return "up"
        Case EXTCHAR & "I": return "pup"

        Case EXTCHAR & "K": return "left"
        Case EXTCHAR & "L": return "center"
        Case EXTCHAR & "M": return "right"

        Case EXTCHAR & "O": return "end"
        Case EXTCHAR & "P": return "down"
        Case EXTCHAR & "Q": return "pdown"

        Case EXTCHAR & Chr(59) To EXTCHAR & Chr(68)
            return "f" & Asc(k, 2) - 58

        Case EXTCHAR & Chr(133) To EXTCHAR & Chr(134)
            return "f" & Asc(k, 2) - 122

        Case Else
            return lcase(k)

    End Select
end function

function dupstr(i as long,s as string) as string
    dim as string ss=""
    dim ii as long
    for ii=0 to i
        ss+=s
    next
    return ss
end function
sub go( x as long,y as long, text as string, fg as long=9,bg as long=0 )
	locate y
    locate ,x
    color fg,bg
	print text;
end sub
sub center(y as long,text as string,fg as long =9,bg as long =0 )
    go((w/2)-(len(text)/2),y,text,fg,bg)
end sub

type frame
    as long x,y,w,h
    as long fg=15,bg=0,nl=1
    as string def(4,8) ={{chr(179),chr(179),chr(196),chr(196),chr(191),chr(218),chr(217),chr(192)},_
                        {chr(186),chr(186),chr(205),chr(205),chr(187),chr(201),chr(188),chr(200)},_
                        {chr(221),chr(222),chr(223),chr(220),chr(219),chr(219),chr(219),chr(219)},_
                        {chr(219),chr(219),chr(219),chr(219),chr(219),chr(219),chr(219),chr(219)}}
    as string l,r,t,b,trc,tlc,brc,blc
    
    declare constructor(xx as integer,yy as integer, ww as integer, hh as integer, set as integer,f as integer, b as integer)
    declare sub use(set as long)
    declare sub redraw()
    declare sub hide()
    
end type

constructor frame(xx as integer,yy as integer, ww as integer, hh as integer, set as integer,f as integer, b as integer)
    x=xx
    y=yy
    w=ww
    h=hh
    fg=f
    bg=b
    use(set)
end constructor

sub frame.use(set as long)
    r=def(set,0)
    l=def(set,1)
    t=def(set,2)
    b=def(set,3)
    trc=def(set,4)
    tlc=def(set,5)
    brc=def(set,6)
    blc=def(set,7)
end sub
sub frame.redraw()
    screenlock
        locate y
        locate ,x
        color fg,bg
        print tlc;
        dim as string cl = r+dupstr(w-2, " ")+l
        print dupstr(w-2, t);
        print trc;
        locate y+1,x
        dim i as long
        for i=(y+1) to (y+h)-1
            locate i,x
            print cl;
        next
        locate y+h,x
        print blc;
        print dupstr(w-2, b);
        print brc;
    screenunlock
end sub
sub frame.hide()
    screenlock
        locate y
        locate ,x
        dim as string cl = dupstr(w, " ")
        dim i as long
        for i=y to (y+h)
            locate i,x
            print cl;
        next
    screenunlock
end sub

sub setsize(byval i as long)
    if i=1 then 
        Width 640\8, 480\16
        res=16
    else 
        Width 640\8, 480\8
        res=8
    end if
    twid = Width()
    w= LoWord(twid): h = HiWord(twid)
end sub
function getmousex() as long
    dim as integer xx,yy
    if xx = -1 then 
        return -1
    end if
    getmouse xx,yy
    return int(640/8)*(xx/640)
end function
function getmousey() as long
    dim as integer yy,xx
    if yy = -1 then 
        return -1
    end if
    getmouse xx,yy
    return int(480/res)*(yy/480)
end function




sub drawascii
    setsize(0)
    cls
    dim as long i,x=2,y=2
    for i = 0 to 256
        locate y,x
        if x+6>w-1 then
            exit for
        end if
        print i;":";chr(i)
        y+=2
        if y>=h-1 then 
            x+=6
            y=2
        end if
    next
    sleep
    dim f as frame =frame(1,1,w-1,h-1,0,9,0)
    f.nl = 0
    f.redraw()
    sleep
    f.use(1)
    f.redraw()
    sleep
    f.use(2)
    f.redraw()
    sleep
    f.use(3)
    f.redraw()
    sleep
    dim as long ww=w,hh=h
    setsize(1)
    cls
    print "bigw:";ww;" bigh:";hh
    print "w:";w;" h:";h
    sleep
end sub



namespace snake
#include "games/snake.bas"
end namespace


namespace spaceinvaders
#include "games/spaceinvaders.bas"
end namespace


namespace defender
#include "games/defender.bas"
end namespace

namespace sweper
#include "games/sweper.bas"
end namespace

namespace breakout
#include "games/breakout.bas"
end namespace

namespace flappybird
#include "games/flappybird.bas"
end namespace


setsize(1)
dim f as frame = frame(1,1,w-1,h-1,0,9,0)
f.nl=0
f.redraw()
dim rules as frame = frame(w-(w/3),3,(w/3)-2,h-5,1,9,0)
dim mfg as frame = frame((w/3),3,(w/3)-2,h-5,2,9,0)
dim scores as frame = frame(3,3,(w/3)-4,h-5,1,9,0)
dim lastg as long = -1
dim g as long = 0
dim as string key
On Error Goto FAILED
do 
    randomize timer
    if lastg<>g then
        f.redraw()
        rules.redraw()
        scores.redraw()
        mfg.redraw()
        center((h/2)-(h/4),"The Arcade Series",9,0)
        center((h/2)-2,"Snake",9,iif(g=0,15,0))
        center((h/2)-1,"Space invaders",9,iif(g=1,15,0))
        center((h/2),"Defender",9,iif(g=2,15,0))
        center((h/2)+1,"Mine sweeper",9,iif(g=3,15,0))
        center((h/2)+2,"Break out",9,iif(g=4,15,0))
        center((h/2)+3,"Flappy bird",9,iif(g=5,15,0))
        center((h/2)+4,"draw ascii",9,iif(g=6,15,0))
        center((h/2)+5,"Exit",9,iif(g=7,4,0))
        if g=0 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "snake";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Play as a snake and eat";
            locate 7,(w-(w/3))+2
            print "apples to increase your";
            locate 8,(w-(w/3))+2
            print "length";
            color 4,0
            locate 10,(w-(w/3))+2
            print "Dont Smack into walls";
            locate 11,(w-(w/3))+2
            print "or your own tail";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("snake",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
            
        elseif g=1 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "space invaders";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Shoot the";
            locate 7,(w-(w/3))+2
            print "invading aliens";
            color 4,0
            locate 8,(w-(w/3))+2
            print "and dont get shot";
            locate 9,(w-(w/3))+2
            print "your self";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("spaceinvaders",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
        elseif g=2 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "defender";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Defend earth from";
            locate 7,(w-(w/3))+2
            print "the invading aliens";
            color 4,0
            locate 8,(w-(w/3))+2
            print "and dont get shot";
            'locate 9,(w-(w/3))+2
            'print "your self";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("defender",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
        elseif g=3 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "Mine sweper";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Find all the bombs in";
            locate 7,(w-(w/3))+2
            print "the feild";
            color 4,0
            locate 8,(w-(w/3))+2
            print "and dont get blown up";
            'locate 9,(w-(w/3))+2
            'print "your self";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("sweper",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
        elseif g=4 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "Break out";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Destroy all the blocks";
            locate 7,(w-(w/3))+2
            print "at the top";
            color 4,0
            locate 8,(w-(w/3))+2
            print "and dont let your";
            locate 9,(w-(w/3))+2
            print "ball fall down";
            'locate 9,(w-(w/3))+2
            'print "your self";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("breakout",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
        elseif g=5 then
            locate 4,(w-(w/3))+2
            color 3,0
            print "Game:";
            color 10,0
            print "Flappy bird";
            color 3,0
            locate 6,(w-(w/3))+2
            print "Fly through the pipes";
            color 4,0
            locate 7,(w-(w/3))+2
            print "and dont hit them";
            'locate 9,(w-(w/3))+2
            'print "your self";
            
            
            color 10,0
            locate 4,5
            print "High scores:";
            color 3,0
            dim as long l,scs(20),i=6
            for l = 0 to getscores("flappybird",scs())
                if scs(l) = 0 then 
                    continue for
                end if
                locate i,5
                print scs(l);
                i+=1
            next
        else 
            color 9,0
            rules.hide()
            scores.hide()
        end if
        lastg=g
    end if
    key = getk()
    if (key="down" or key="s") and g<>7 then
        g+=1
    elseif (key="up" or key="w") and g<>0 then
        g-=1
    elseif (key=" " or key=!"\r") then
        if g=7 then
            end
        elseif g=0 then
            snake.main()
        elseif g=1 then
            spaceinvaders.main()
        elseif g=2 then
            defender.main()
        elseif g=3 then 
            sweper.main()
        elseif g=4 then 
            breakout.main()
        elseif g=5 then 
            flappybird.main()
        elseif g=6 then 
            drawascii()
        end if
        lastg=-1
        setsize(1)
        while inkey <>""
        wend
    end if
    
loop while 1
end
FAILED:
Dim e As Integer
e = Err
Print e
Sleep
End
