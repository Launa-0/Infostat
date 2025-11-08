class Item:
    def __init__(self, name, vendor, category, price, cost, weight):
        self.name = name
        self.vendor = vendor
        self.category = category
        self.price = price
        self.cost = cost
        self.weight = weight

    def increase_cost(self, rate):
        self.cost = self.cost * (1 + rate / 100)

    def profit(self):
        return self.price - self.cost


if __name__ == '__main__':
    items = [Item(name="포테이토칩", vendor="농심", category="과자류", price=1800, cost=1300, weight=300),
             Item(name="액츠파워젤", vendor="피죤", category="세탁세제류", price=20770, cost=13500, weight=4.2),
             Item(name="대천김 도시락김 5g(54봉)", vendor="케이앤비컴퍼니", category="식품류", price=18300, cost=10000, weight=300)]

    items[2].increase_cost(15.00)

    total_profit = 0
    for item in items:
        #print(f'{item.profit()}')
        total_profit += int(item.profit())
    print(f'총 판매 이익금: {total_profit}원')