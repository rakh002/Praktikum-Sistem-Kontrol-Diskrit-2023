G = tf([1], [1 2])
Gd1 =  c2d(G, 0.5)
Gd = tf([1 0],[1 -1], 0.5)

figure(1)
rlocus(Gd*Gd1)
figure(2)
step(feedback(Gd*Gd1, 1), feedback(8*Gd*Gd1, 1), feedback(9*Gd*Gd1, 1))
axis([0 12 -3 3])