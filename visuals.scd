(
Server.default.waitForBoot;
{

	OSCdef.new(\getwaves, {
		arg msg, time, addr, recvPort;
		~radius = msg[1].linlin(0, 100, 100, 200);
		~change = msg[1].linlin(0, 100, 0.1, 1);
		~fps = msg[1].linlin(0, 100, 0, 10);
    }, '/neurovals'
	);

	{
		//vars
		var width= 640, height= 480;
		var w= Window("bright", Rect(99, 99, width, height), false);
		var u= UserView(w, Rect(0, 0, width, height));

		//drawfunction
		u.drawFunc= {

			Pen.translate(width*0.5, height*0.5);
			Pen.fillColor= Color.grey(~change, ~change);
			Pen.fillOval(Rect.aboutPoint(Point(0, 0), ~radius, ~radius));

		};

		//--window
		u.clearOnRefresh= true;
		u.background= Color.grey(0.5);
		w.front;
		u.animate= true;


	}.defer(1);

    o = OSCFunc({arg msg;
        {
            a.value = msg[1].linlin(0, 100, 0, 1);
            b.value = msg[2].linlin(0, 100, 0, 1);
            c.value = msg[3].linlin(-500, 500, 0, 1);
            d.value = msg[4].linlin(1000, 1000000, 0, 1);
            e.value = msg[5].linlin(1000, 200000, 0, 1);
            f.value = msg[6].linlin(1000, 200000, 0, 1);
            g.value = msg[7].linlin(1000, 70000, 0, 1);
            h.value = msg[8].linlin(1000, 70000, 0, 1);
            i.value = msg[9].linlin(1000, 70000, 0, 1);
            k.value = msg[10].linlin(1000, 50000, 0, 1);
            l.value = msg[11].linlin(100, 30000, 0, 1);
            m.value = msg[12].linlin(0, 200, 0, 1);
            n.value = msg[13].linlin(0, 200, 0, 1);
		}.defer(1);

    }, '/neurovals',
	);

	{

		w = Window("datameter", Rect(700, 700, 630, 200));
		w.front;
		a = LevelIndicator(w, Rect(10, 10, 20, 180));
		a.numSteps = 100;
		b = LevelIndicator(w, Rect(50, 10, 20, 180));
		b.numSteps = 100;
		c = LevelIndicator(w, Rect(100, 10, 20, 180));
		c.numSteps = 100;
		d = LevelIndicator(w, Rect(150, 10, 20, 180));
		d.numSteps = 100;
		e = LevelIndicator(w, Rect(200, 10, 20, 180));
		e.numSteps = 100;
		f = LevelIndicator(w, Rect(250, 10, 20, 180));
		f.numSteps = 100;
		g = LevelIndicator(w, Rect(300, 10, 20, 180));
		g.numSteps = 100;
		h = LevelIndicator(w, Rect(350, 10, 20, 180));
		h.numSteps = 100;
		i = LevelIndicator(w, Rect(400, 10, 20, 180));
		i.numSteps = 100;
		k = LevelIndicator(w, Rect(450, 10, 20, 180));
		k.numSteps = 100;
		l = LevelIndicator(w, Rect(500, 10, 20, 180));
		l.numSteps = 100;
		m = LevelIndicator(w, Rect(550, 10, 20, 180));
		m.numSteps = 100;
        n = LevelIndicator(w, Rect(600, 10, 20, 180));
		n.numSteps = 100;

	}.defer(1);

}.fork;
)














