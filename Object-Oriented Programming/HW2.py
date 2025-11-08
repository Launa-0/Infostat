import turtle


class Point:
    def __init__(self, x=0, y=0):
        self.__x = x
        self.__y = y

    @property
    def x(self):
        return self.__x

    @property
    def y(self):
        return self.__y

    def move(self, x, y):
        self.__x = x
        self.__y = y

    def __str__(self):
        return f"({self.__x},{self.__y})"


class Rectangle:
    def __init__(self, width, height, color, base_point=Point(x=0, y=0)):
        self.__width = width
        self.__height = height
        self.__color = color
        self.__base_point = base_point

    @property
    def width(self):
        return self.__width

    @property
    def height(self):
        return self.__height

    @property
    def color(self):
        return self.__color

    @property
    def base_point(self):
        return self.__base_point

    @property
    def area(self):
        return self.__width*self.__height

    @property
    def perimeter(self):
        return 2*(self.__width+self.__height)

    def draw(self):
        pen = turtle.Turtle()
        pen.pencolor("black")
        pen.fillcolor(self.__color)
        pen.speed(0)

        pen.penup()
        pen.goto(self.__base_point.x, self.__base_point.y)
        pen.pendown()

        pen.begin_fill()
        for side in [self.__width, self.__height]*2:
            pen.forward(side)
            pen.left(90)

        pen.end_fill()
        pen.hideturtle()

    def move(self, other: "Point"):
        self.__base_point = other

    def __str__(self):
        info = f"기준점(좌측 하단): {self.__base_point}\n"
        info += f" 가로 :{self.width}\t세로 : {self.height}\n"
        info += f"면적:{self.area}\t 둘레:{self.perimeter}"
        return info

if __name__=="__main__":
    x, y = -200, -200
    width, height = 400, 200
    colors = ['green', 'red']

    rectangles = []
    for n in range(5):
        r = Rectangle(width, height, colors[n % 2], Point(x, y))
        print(r)
        rectangles.append(r)


        if width % 2 != 0:
            width //=2
            width += 1
        else:
            width //= 2

        if height % 2 != 0:
            height //= 2
            height += 1
        else:
            height //= 2

        #width //= 2
        #height //= 2
        x += height
        y += width

    for rectangle in rectangles:
        rectangle.draw()

    turtle.done()
