# Path Commands

Here lists all possible SVG Path `d` commands.

Commands are all single letter string with two favors followed by coordinate pairs or params:

 - Upper Case: absolute offset 
 - Lower Case: relative offset

All possible 10 letters (in upper case without their lower case counterpart):

 - M, L, H, V: straight line move / line to 
 - C, S: Cubic Bezier (with two control points)
 - Q, T: Quadratic Bezier (shared control points)
 - A: Arc
 - Z: close path


## Usage

assume last point to be (cx, cy).

 - Straight Line: 
   - M (x y)+: move to (x,y). subseq (x,y) becomes L (x y)
   - m (dx dy)+: move to (cx + dx, cy + dy). subseq (dx,dy) becomes l (dx dy)
   - L (x y)+: line to (x,y). subseq (x,y) becomes L (x y)
   - m (dx dy)+: line to (cx + dx, cy + dy). subseq (dx,dy) becomes l (dx dy)
   - H x+: horizontal line to (x,cy). subseq (x) becomes H (x)
   - h dx+: horizontal line to (x,cy). subseq (x) becomes h (dx)
   - V y+: vertical line to (cx, y). subseq (x,y) becomes V (x)
   - v dy+: vertical line to (cx, y). subseq (x,y) becomes v (dy)
 - Cubic Bezier
   - two anchors for each point. with `S`, the first anchor is deducted automatically.
     - C (x1 y1 x2 y2 x y)+
       - cubic bezier to (x,y) with 1st anchor (x1,y1) / 2nd anchor (x2,y2).
       - subseq (x1 y1 x2 y2 x y) = C (x1 y2 x2 y2 x y)
     - c (dx1 dy1 dx2 dy2 dx dy)+
       - cubic bezier to (cx + dx,cy + dy) with the 1st anchor (cx + dx1, cy + dy1) / 2nd anchor (cx + dx2,cy + dy2).
       - subseq (dx1 dy1 dx2 dy2 dx dy) = C (dx1 dy1 dx2 dy2 dx dy)
     - S (x2 y2 x y)+
       - cubic bezier to (x,y) with 2nd anchor (x2,y2). and 1st anchor deducted from last 2nd anchor.
       - subseq (x2 y2 x y) = S (x2 y2 x y)
     - s (dx2 dy2 dx dy)+
       - cubic bezier to (cx +dx,cy + dy) with 2nd anchor (cx + dx2,cy + dy2). 1st anchor auto deducted
       - subseq (dx2 dy2 dx dy) = S (dx2 dy2 dx dy)
 - Quadratic Bezier
   - one shared anchors for each curve. with `T`, the anchor is deducted automatically.
     - Q (x1 y1 x y)+
       - cubic bezier to (x,y) with the shared anchor (x1,y1)
       - subseq (x1 y1 x y) = Q (x1 y2 x y)
     - q (dx1 dy1 dx dy)+
       - cubic bezier to (cx + dx,cy + dy) with the shared anchor (cx + dx1, cy + dy1)
       - subseq (dx1 dy1 dx dy) = q (dx1 dy1 dx dy)
     - T (x y)+
       - cubic bezier to (x,y) with auto deducted shared anchor.
       - subseq (x y) = T (x y)
     - t (dx dy)+
       - cubic bezier to (cx +dx,cy + dy) with auto deducted shared anchor.
       - subseq (dx dy) = t (dx dy)
 - Arc
   - A (rx ry angle large-arc-flag sweep-flag x y)+
     - draw an arc from (cx, cy) to (x,y) with radius (rx, ry)
     - angle: rotate in degree related to x axis.
     - large-arc-flag: 0 = small, 1 = large
     - sweep-flag: 0 = ccw, 1 = cw
