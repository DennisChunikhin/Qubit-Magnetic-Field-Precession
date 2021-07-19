% Initial state
global psi_0;
psi_0 = [1/sqrt(2); 1/sqrt(2)];

% Magnetic field
B = [rand()*4 - 2, rand()*4 - 2, rand()*4 - 2];

% Pauli matrices
sigma_x = [0, 1; 1, 0];
sigma_y = [0, -1i; 1i, 0];
sigma_z = [1, 0; 0, -1];

% Hamiltonian
global H;
H = B(1)*sigma_x + B(2)*sigma_y + B(3)*sigma_z;

% Time evolution unitary operator
function U = U(t)
  global H;
  U = expm(-1i*t*H);
end

% The quantum state
function psi = psi(t)
  global psi_0;
  psi = U(t)*psi_0;
end

% Get bloch vector of state
function [theta, phi] = toBloch(state)
  theta = 2 * acos(min(abs(state(1)), 1));
  phi = angle(state(2)) - angle(state(1));
end

% Convert spherical coords to cartesian coords
function [x, y, z] = sphericalToCartesian(theta, phi)
  x = cos(phi)*sin(theta);
  y = sin(phi)*sin(theta);
  z = cos(theta);
end


% Build arrays of all important values for every time t
t = linspace(0, 2*pi, 1000);

for i = 1:length(t)
  t_i = t(i);
  
  state = psi(t_i);
  [theta, phi] = toBloch(state);
  [x_i, y_i, z_i] = sphericalToCartesian(theta, phi);
  
  % Coords of bloch vector
  x(i) = x_i;
  y(i) = y_i;
  z(i) = z_i;
  
  % Probability of measuring a 0
  P(i) = (abs(state(1)))^2;
  
  statedag = state';
  
  % Expectation values of the pauli matrices
  expect_x(i) = statedag*sigma_x*state;
  expect_y(i) = statedag*sigma_y*state;
  expect_z(i) = statedag*sigma_z*state;
  
  % Fidelity of (probability of measuring) initial state
  fidelity(i) = abs(psi_0' * state)^2;
end


% Create plot animation
fig = figure();

% Bloch sphere
subplot(3,2,[1,3,5])
qubit_plot = plot3(x(1), y(1), z(1));
hold on
bloch_vector = plot3([0, x(1)],[0, y(1)],[0, z(1)],'r-^', 'LineWidth',3);
hold on
% Magnetic field
quiver3(0, 0, 0, B(1), B(2), B(3), 'Color', 'b');
hold on
% Draw axes
quiver3(0, 0, 0, 1, 0, 0, 'Color', 'k');
text(1.1, 0, 0, "X", 'FontSize', 20)
hold on
quiver3(0, 0, 0, 0, 1, 0, 'Color', 'k');
text(0, 1.1, 0, "Y", 'FontSize', 20)
hold on
quiver3(0, 0, 0, 0, 0, 1, 'Color', 'k');
text(0, 0, 1.1, "Z", 'FontSize', 20)
hold on
% Draw sphere
[x_s, y_s, z_s] = sphere;
h = surf(x_s, y_s, z_s, 'FaceAlpha', 0.1); 
shading interp

dim_max = max([abs(B(1)), abs(B(2)), abs(B(3)), 1]);
axis([-dim_max, dim_max, -dim_max, dim_max, -dim_max, dim_max])
pbaspect([1, 1, 1])
xlabel("X axis")
ylabel("Y axis")
zlabel("Z axis")
title("Bloch Sphere", 'FontSize', 20)
grid on

view(120, 25)

% Probability plot
subplot(3,2,2)
probPlot = plot(t(1), P(1), '-');
xlabel("Time", 'FontSize', 16)
ylabel("Probability of Measuring 0", 'FontSize', 16)
axis([0, 7, 0, 1])

% Fidelity plot
subplot(3,2,4)
fidelity_plot = plot(t(1), fidelity(1), '-');
xlabel("Time", 'FontSize', 16)
ylabel("Fidelity of the Initial State", 'FontSize', 16)
axis([0, 7, 0, 1])

% Expectation value plot
subplot(3,2,6)
x_plot = plot(t(1), expect_x(1), "DisplayName", "Pauli X", '-');
hold on
y_plot = plot(t(1), expect_y(1), "DisplayName", "Pauli Y", '-');
hold on
z_plot = plot(t(1), expect_z(1), "DisplayName", "Pauli Z", '-');
xlabel("Time", 'FontSize', 16)
ylabel("Expectation Value", 'FontSize', 16)
axis([0, 7, -1, 1])
legend("Pauli X", "Pauli Y", "Pauli Z");

% Animate
for i = 1:length(t)
  set(qubit_plot, 'XData', x(1:i))
  set(qubit_plot, 'YData', y(1:i))
  set(qubit_plot, 'ZData', z(1:i))
  
  set(bloch_vector, 'XData', [0, x(i)])
  set(bloch_vector, 'YData', [0, y(i)])
  set(bloch_vector, 'ZData', [0, z(i)])
  
  set(probPlot, 'YData', P(1:i))
  set(probPlot, 'XData', t(1:i))
  
  set(x_plot, 'YData', expect_x(1:i))
  set(x_plot, 'XData', t(1:i))
  
  set(y_plot, 'YData', expect_y(1:i))
  set(y_plot, 'XData', t(1:i))
  
  set(z_plot, 'YData', expect_z(1:i))
  set(z_plot, 'XData', t(1:i))
  
  set(fidelity_plot, 'YData', fidelity(1:i))
  set(fidelity_plot, 'XData', t(1:i))
  
  pause(0.05)
end