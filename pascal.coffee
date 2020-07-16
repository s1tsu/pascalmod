math = Math
mcos = math.cos
msin = math.sin
mabs = math.abs
mround = math.round
matan = math.atan2
msqrt = math.sqrt
mmin = math.min
mmax = math.max
mPI = math.PI
mrandom = math.random
mfloor = math.floor
mceil = math.ceil
mhrt = msin(mPI/3)


Array::randomElement = ->
        return this[mrandom() * this.length | 0]

Array::nextRow = ->
        a = (this[i-1]+this[i] for i in [1...this.length])
        a.push(1)
        a.unshift(1)
        return a

Array::nextRowMod = (m) ->
        a = ((this[i-1]+this[i])%m for i in [1...this.length])
        a.push(1)
        a.unshift(1)
        return a

Array::last = ->
        @[this.length - 1]


binomMod = (n,m) ->
        binoms = [[1]]
        while binoms.length < n
                binoms.push(binoms.last().nextRowMod(m))
        return binoms



class PascalTri 
        constructor: (n,el,m) ->
                @labels = new Array
                @ul = el/(n-1)
                @translatey = -0.4*el
                @translatex = 0
                @m = m
                @n = n


        drawCircles: (ctx,carray,binmod,shown) ->
                ctx.save()
                ctx.translate(@translatex, @translatey)
                for y in [0...@n]
                        for x in [0..y]
                                ctx.beginPath()
                                ctx.arc(x*@ul-y*@ul/2,y*@ul*mhrt,@ul/2,0,2*mPI)
                                ctx.fillStyle = carray[binmod[y][x]]
                                ctx.fill()
                                if shown
                                        ctx.fillStyle = "#ffffff"
                                        ctx.fillText(binmod[y][x],x*@ul-y*@ul/2,y*@ul*mhrt,@ul/2)

                # ctx.beginPath()
                # ctx.arc(-el/2,el*mhrt,@ul/2,0,2*mPI)
                # ctx.fillStyle = "#880000"
                # ctx.fill()
                # ctx.beginPath()
                # ctx.arc(el/2,el*mhrt,@ul/2,0,2*mPI)
                # ctx.fillStyle = "#008800"
                # ctx.fill()
                # ctx.beginPath()
                # ctx.arc(0,0,@ul/2,0,2*mPI)
                # ctx.fillStyle = "#000088"
                # ctx.fill()

                                

                ctx.restore()
                


        drawTriangles: (ctx) ->
                ctx.save()
                ctx.translate(@translatex, @translatey)
                for x in [0...n]
                        for y in [0...n-x]
                                ctx.beginPath()
                                ctx.moveTo(x*@ul,-y*@ul)
                                ctx.lineTo((x+1)*@ul,-y*@ul)
                                ctx.lineTo(x*@ul,-(y+1)*@ul)
                                ctx.closePath()
                                ctx.stroke()
                ctx.restore()


        
        # drawLabels: (ctx) ->
        #         ctx.save()
        #         ctx.translate(@translatex, @translatey)
        #         for x in [0..n]
        #                 for y in [0..n-x]
        #                         ctx.fillText(@labels[x][y], x*@ul, -y*@ul)
        #         ctx.restore()













cw = window.innerWidth
ch = window.innerHeight


container = document.createElement('div')
document.body.appendChild( container )




# もうちょっとよいやり方があるだろう
# fullcanvas = document.createElement('canvas')
# container.appendChild(fullcanvas)
# fullcanvas.width = cw
# fullcanvas.height = ch
# fctx = fullcanvas.getContext "2d"
# fctx.transform(1,0,-mcos(mPI/3),msin(mPI/3),0.5*cw,0.5*ch)

trianglescanvas = document.createElement('canvas')
container.appendChild(trianglescanvas)
trianglescanvas.width = cw
trianglescanvas.height = ch
tctx = trianglescanvas.getContext "2d"
tctx.transform(1,0,0,1,0.5*cw,0.5*ch)
tctx.textAlign = "center"
tctx.textBaseline = "middle"

# labelscanvas = document.createElement('canvas')
# container.appendChild(labelscanvas)
# labelscanvas.width = cw
# labelscanvas.height = ch
# lctx = labelscanvas.getContext "2d"
# lctx.transform(1,0,-mcos(mPI/3),msin(mPI/3),0.5*cw,0.5*ch)




clearCanvas = (ctx) ->
        ctx.save()
        ctx.setTransform(1,0,0,1,0,0)
        ctx.clearRect(0,0,cw,ch)
        ctx.restore()



#
# フォントや色はこちらで設定
# 
# lctx.textAlign = "center"
# lctx.textBaseline = "middle"
# lctx.font = '20pt Arial'
# fctx.font = '40pt Arial'

bgcol = '#ffffff'

# full labeled triangle color
fullLColor = '#ff6e00bb'
# color for labels
lColor = "#9000c0"

# wall line width
wlineWidth = 2

# path line
plineColor = "red"
plineWidth = 4

# edge length of the outer triangle
el = 0.8*mmin(cw,ch)

# number of edge subdivision
n = 4

# modulo
m = 2

startColor = "#ffffff"
endColor = "#0000ff"

tri = new PascalTri(n,el,m)


guiparam = {
        subdivision: n
        mod: m
        showNumber: true
        startcolor: startColor
        endcolor: endColor
        naturalGradation: false
        }

gui = new dat.GUI()

gui.add( guiparam, 'subdivision', 2,256,1).onChange( (val) -> redraw(val);return )
gui.add( guiparam, 'mod', 2,15,1).onChange( (val) -> redraw(val);return )
gui.add( guiparam, 'showNumber').onChange( (val) -> redraw(val);return )
gui.addColor( guiparam, 'startcolor').onChange( (val) -> redraw(val);return )
gui.addColor( guiparam, 'endcolor').onChange( (val) -> redraw(val);return )
gui.add( guiparam, 'naturalGradation').onChange( (val) -> redraw(val);return )

col_array = (sc,ec,m,nat=true) ->
        if nat
                scs = (parseInt(sc.substring(i,i+2),16) for i in [1,3,5])
                ecs = (parseInt(ec.substring(i,i+2),16) for i in [1,3,5])
                return ('#'+(mfloor((i*ecs[0] + (m-1-i)*scs[0])/(m-1))).toString(16).padStart(2,'0')+(mfloor((i*ecs[1] + (m-1-i)*scs[1])/(m-1))).toString(16).padStart(2,'0')+(mfloor((i*ecs[2] + (m-1-i)*scs[2])/(m-1))).toString(16).padStart(2,'0') for i in [0...m])
        else
                sci = parseInt(sc.substring(1),16)
                eci = parseInt(ec.substring(1),16)
                return ('#'+(mfloor((i*eci + (m-1-i)*sci)/(m-1))).toString(16).padStart(6,'0') for i in [0...m])

redraw = (val) ->
        n = guiparam.subdivision
        m = guiparam.mod
        shown = guiparam.showNumber
        sc = guiparam.startcolor
        ec = guiparam.endcolor
        ng = guiparam.naturalGradation
        carray = col_array(sc,ec,m,ng)
        tri = new PascalTri(n,el,m)


        
        # # full label
        # clearCanvas(fctx)
        # fctx.save()
        # fctx.fillStyle = fullLColor
        # tri.fillFullLabel(fctx)
        # fctx.restore()



        # triangle
        clearCanvas(tctx)
        tri.drawCircles(tctx,carray,binomMod(n,m),shown)



        # # labels
        # clearCanvas(lctx)
        # lctx.save()
        # lctx.fillStyle = lColor
        # tri.drawLabels(lctx)
        # lctx.restore()


        return


redraw()








