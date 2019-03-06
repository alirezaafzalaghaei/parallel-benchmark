import matplotlib.pyplot as plt
import seaborn as sns
import operator
import sys
sns.set()

with open(sys.argv[1]) as results:
    data = results.read().strip().split('\n')
    processed = {}
    NAMES = data[0].split()
    print("{:5s}".format(NAMES[0]), end=' ')
    NAMES.pop(0)
    for name in NAMES:
        print("%10s" % (name), end=' ')
    print('')

    for line in data[1:]:
        tmp = list(map(float, line.split()))
        processed[tmp[0]] = tmp[1:]
        print("{:4d} {:10.6f}".format(int(tmp[0]), tmp[1]), end=' ')
        for x in tmp[2:]:
            print("{:10.6f}".format(x), end=' ')
        print('')

    result = []
    for i in range(len(NAMES)):
        result.append(
            list(
                zip(processed.keys(),
                    map(operator.itemgetter(i), processed.values()))))

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(9, 9))
    for i, res in enumerate(result):
        ax1.plot(*zip(*res), '.-', label=NAMES[i], markersize=14)

    ax1.legend()

    efficiency = [v[0] / v[1] if v[0] >= v[1] else -v[1] / v[0] for v in processed.values()]
    x = list(map(str, map(int, processed.keys())))

    ax2.bar(
        x, efficiency, width=0.5, color=(0.2, 0.3, 0.1, 0.3), edgecolor='blue')

    for i, eff in enumerate(efficiency):

        ax2.annotate(
            round(eff, 1) if eff>=0 else round(eff), xy=(x[i], eff), xytext=(i - .15, eff + 0.04))
    a = ax2.get_yticks().tolist()
    a.append(a[-1]+(a[-1]-a[-2]))
    ax2.set_yticks(a)
    plt.show()
