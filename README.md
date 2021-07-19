# Qubit Magnetic Field Precession
A MATLAB script visualizing the time evolution of a qubit under a static magnetic field.  
More generally, the script also represents the precession of the spin of a particle about a magnetic field (a case of Larmor precession).  
## The Visualization

The visualization includes:  
 - a Bloch sphere representation of the qubit
 - a plot of the probability of measuring 0 over time
 - a plot of the fidelity of the initial state over time
 - a plot of the expectation values of the Pauli X, Y, and Z operators over time.  
<br\>
The magnetic field is randomized but can be set by changing the B vector.  
The initial state is
```math
\ket{+}
```
but can be set by changing the psi_0 vector.  
