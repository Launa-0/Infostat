import math
from abc import ABC, abstractmethod
import math


class Shape(ABC):
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        return self._name

    @property
    @abstractmethod
    def area(self):
        ...

    @property
    @abstractmethod
    def volume(self):
        ...


class Rectangle(Shape):
    def __init__(self, name, width, height):
        super().__init__(name)
        self.__width = width
        self.__height = height

    @property
    def width(self):
        return self.__width

    @width.setter
    def width(self, width):
        self.__width = width

    @property
    def height(self):
        return self.__height

    @height.setter
    def height(self, height):
        self.__height = height

    @property
    def area(self):
        return self.width * self.height

    @property
    def volume(self):
        return 0

    def __str__(self):
        info = f'도형 종류: {self.name} (가로: {self.width}, 세로: {self.height})\n'
        info += f'면적:{self.area: .3f}, 체적:{self.volume: .3f}'
        return info


class Box(Rectangle):
    def __init__(self, name, width, height, depth):
        super().__init__(name, width, height)
        self.__depth = depth

    @property
    def depth(self):
        return self.__depth

    @depth.setter
    def depth(self, depth):
        self.__depth = depth

    @property
    def area(self):
        return 2 * (self.width*self.height+self.width*self.depth+self.depth*self.height)

    @property
    def volume(self):
        return self.width * self.height*self.depth

    def __str__(self):
        info = f'도형 종류: {self.name} (가로: {self.width}, 세로: {self.height}, 높이: {self.depth})\n'
        info += f'겉넓이:{self.area: .3f}, 체적:{self.volume: .3f}'
        return info


class Circle(Shape):
    def __init__(self, name, radius):
        super().__init__(name)
        self.__radius = radius

    @property
    def radius(self):
        return self.__radius

    @radius.setter
    def radius(self, radius):
        self.__radius = radius

    @property
    def area(self):
        return math.pi * math.pow(self.radius, 2)

    @property
    def volume(self):
        return 0

    def __str__(self):
        info = f'도형 종류: {self.name} (반지름: {self.radius})\n'
        info += f'면적:{self.area: .3f}, 체적:{self.volume: .3f}'
        return info


class Cylinder(Circle):
    def __init__(self, name, radius, height):
        super().__init__(name, radius)
        self.__height = height

    @property
    def height(self):
        return self.__height

    @height.setter
    def height(self, height):
        self.__height = height

    @property
    def area(self):
        return 2 * math.pi * math.pow(self.radius, 2) + 2 * math.pi * self.height * self.radius

    @property
    def volume(self):
        return math.pi * math.pow(self.radius, 2) * self.height

    def __str__(self):
        info = f'도형 종류: {self.name} (반지름: {self.radius}, 높이: {self.height})\n'
        info += f'겉면적:{self.area: .3f}, 체적:{self.volume: .3f}'
        return info


class Sphere(Circle):
    def __init__(self, name, radius):
        super().__init__(name, radius)

    @property
    def area(self):
        return 4 * math.pi * math.pow(self.radius, 2)

    @property
    def volume(self):
        return 4 / 3 * math.pi * math.pow(self.radius, 3)

    def __str__(self):
        info = f'도형 종류: {self.name} (반지름: {self.radius})\n'
        info += f'겉면적:{self.area: .3f}, 체적:{self.volume: .3f}'
        return info


if __name__ == '__main__':
    rect = Rectangle("Rectangle", 10.0, 5.0)
    print(rect)

    box = Box("Box", 10.0, 5.0, 30.0)
    print(box)

    circle = Circle("Circle", 20.0)
    print(circle)

    cylinder = Cylinder("Cylinder", 20.0, 50.0)
    print(cylinder)

    sphere = Sphere("Sphere", 20.0)
    print(sphere)
