a = 9;
b = 3;
c = 4;

when(c == 1) {
	d = a + b;
}
other {
	when(c==2) {
		d = a-b;
	}
	other {
		when(c==3) {
			d= a*b;
		}
		other {
			d = a/b;
		}
	}
}
show(d);