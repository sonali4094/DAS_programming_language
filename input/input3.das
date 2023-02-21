n=6;

a = 1;
b = 1;
when(n<=2) {
	show(1);
}
other {
trap_until(n>=3) {
	c= a+b;
	a=b;
	b=c;
	n = n-(1);
}
show(c);
}