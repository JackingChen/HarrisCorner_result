# Your Name <span style="color:red">(yout cs id)</span>

# Project 1 / Image Filtering and Hybrid Images

## Overview
The project is related to 
> quote


## Implementation
1. One
	* item
	* item
2. Two

```
Code highlights
```
## Experiment
1. change the gradient filter size
```
dx = [-1 0 0 0 0 0 1; -1 0 0 0 0 0 1; -1 0 0 0 0 0 1];
dx = [-1 0 0 0 1; -1 0 0 0 1; -1 0 0 0 1];
dx = [-1 0 1; -1 0 1; -1 0 1];
```
result:
<img src="./tune gradient filter/little.jpg" width="24%"/>
<img src="./tune gradient filter/medium.jpg" width="24%"/>
<img src="./tune gradient filter/large.jpg" width="24%"/>
disussion: seems that the smallest gradient filter has the best result

2. changing the order filter (for complementing maxium filter) size
result:
<img src="./tune r/little.jpg" width="24%"/>
<img src="./tune r/r=4.jpg" width="24%"/>
<img src="./tune r/r=6.jpg" width="24%"/>
discussion: seems tuning r did not have effect on interest point (corner dection)
3. tuning the threshold
<img src="./tune threshold/100.jpg" width="24%"/>
<img src="./tune threshold/150.jpg" width="24%"/>
<img src="./tune threshold/200.jpg" width="24%"/>
<img src="./tune threshold/300.jpg" width="24%"/>
discussion: I think setting the threshold to 150 should be the best result
## Installation
* Other required packages.
* How to compile from source?

### Results

<table border=1>
<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

</table>

