/**
	Multiline comment
**/

// Class declaration
class Base
{
	// Member field
	private int someValue;

	// Constructor
	public void construct()
	{
		someValue = 42; // assign operator
	}

	public void destruct()
	{}

	private void someFunc()
	{}

	protected void someOtherFunc(int val)
	{
		int a;
		float b = 12 + someValue;

		// Branches
		if (b > 40) {
			a = b;
		} else {
			print("b > 40!");
		}

		if (b == 54) {
			print("ok");
		}

		// Function call
		someFunc();
	}
};

class Bakery: Base
{
	Bread lastBread; // field declaration with default access type(private)
	Bread breads[]; // dynamic array declaration

	Bread bakeBread(int breadType) // method declaration with default access type(public)
	{
		Bread bread = Bread::new();

		this.lastBread = bread;

		// Method calls
		bread.setType(breadType);
		bread.setName("Sweety" + "Pony");
		bread.bake();

		return bread;
	}

	void doUselessStuff()
	{
		Bread bread = bakeBread(11);

		print(bread.getName());

		delete(bread);
	}
};

void func()
{
	Bakery bakery = Bakery::new();

	Bread breads[128]; // static array declaration

	breads[0] = bakery.bakeBread(123);
	breads[getBreadIndex()] = bread12;

	bakery.breads[11] = 0;
}

void func2(int a, int b, float c)
{}

// Some random stuff follows

int a;

float b = 42;
double c = getC();

foo();
bar(foo(c, doo(a, too(b))), a, b, c);

baz(12);
kott(1234.12);

char getRandomChar()
{
	if (getProbability()) {
		return 'A';
	}

	return 'C';
}

// this won`t work now
//assert(getRandomChar() == 'A');

// this won`t work now
//int v = (a * c) + (v - d);

drr(12 + 4, 6 * fourtyTwo, 1 / 2, aa - bb);

//int v = (a * c) + (v - d);