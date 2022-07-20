---
thumbnail: /projects/avatar/thumbnail.jpg
title: "Avatar"
startDate: "2022-06-13"
description: "My homemade VR game engine"
tags:
- Avatar
- VR
---

## Roadmap
* 👨‍💻 0.1.0 - Initial Version
    * [x] Display a window using WinRT
    * [x] Initialize Dx12 with a clear color
    * [x] Draw a hard-coded cube
    * [ ] Auto rotate the cube
    * [ ] Load a slightly complex cube from an object file (FBX? OBJ?)
    * [ ] Add texture to the cube (Stargate's ancient healing device)
    * [ ] Add  diffuse lighting inside the healing device
    * [ ] Create another build for OpenXR
    * [ ] Initialize OpenXR
    * [ ] Render the scene in OpenXR
    * [ ] Unit tests + CI ?

## DevLogs

### 05-11-2022

Here it is, I think that the 5 or 6th iteration of this project I made so far.
Not that I don't like it, on the contrary. I just can't decide the tech to use.
I've tried Java (discarded because of the early support of OpenXR from LWJGL),
Unreal (good, but too much "clicky-clicky mouse" and not enough control
over the sources/possibilities), Web (but... even if it's my day-to-day work, 
I somehow grew tired of the Web community to not wanted to see it on my side 
project).

So here we go, plain old C++, with my own rules and my own standard, let see
where it goes.

I think I'll maintain several txt files as documentations over my work and the 
project itself (maybe I'll also extract blog post for my website to come).

-- 

Enough for tonight (yep, I'm working the night those times). I've setup the 
project in Visual Studio with a basic Hello World popup using WinRT lib, read
a bunch of documentations about Dx12, and found a [great 
repository](https://github.com/d3dcoder/d3d12book) full of examples on how to 
do certain things with Dx12 and it's 
[C# translation](https://github.com/discosultan/dx12-game-programming) which I 
hope should contain more implementation details or notes (just examples in the 
ReadMe made me impatient to start).

I've also added a bunch of todos with some kind of pseudocode / explanation
to help me structure my thought process. Hope it will help.

I'll rethink about the organization of those notes, maybe host them too on 
my future website? But for the moment, in the project's git repository is 
fine enough.

--- 

### 05-12-2022

Purpose of the engine is to make it as agnostic as possible from the hardware it 
runs on. I got a good architecture in mind after watching [Casey Muratori's 
handmade hero](https://www.youtube.com/c/MollyRocket/playlists) and [Tommy 
Refenes](https://isetta.io/interviews/TommyRefenes-interview/) takes on the 
structure of a Game Engine. I'll do a blogpost on it maybe.

Our Engine module will hold all the "logic" (like the ECS system, saves, 
IA...) for the game, and it will also expose interface for Hardware's 
specific implementations (for example "Platform" and "Renderer"). Take a 
note that:
* a "Platform" is an interface for handling Input/Output interfaces 
    with the user (like windowing system and keyboard/mouse inputs for 
    Windows, or HMD and controllers for OpenXR).
* a "Renderer" is an interface for handling Graphic drawing (like 
    DirectX or Vulkan).

Then we may get two specific implementations for Windows: 
* WinRTPlatform which will implement the Platform for a classic WinRT
    windowing system
* Dx12Renderer which will implement the Renderer for displaying graphics
    using DirectX 12.

Those modules will then be included as static library inside the Game module.
The Game module will create a speicfic "BuildTarget" class for a configuration
(like WinRTPlatform + Dx12Renderer, or another class for WinRTPlatform + 
VulkanRenderer), and that will be the only direct calls to hardware specific 
code in the Game module. Every other implementation details will use Engine 
classes only to maintain this abstract.

This way, if tomorrow will have to support another kind of build (like, let's 
say... OpenXR for WindowsMixedReality =) ), we will only have to do this at the
top of the `main.cpp` in the Game module: 

```
#ifdef WINDOWS_BUILD
#define BUILDTARGET WindowsBuildTarget
#elif WMR_BUILD
#define BUILDTARGET WMRBuildTarget
#endif

int wWinMain(/*...*/) {
    BuildTarget target = BUILDTARGET();
    target.setTitle("appName");
    /* ... */
}
```

--

It works \o/ (yep, I did an happy dance).

I must finish the error handling, but I'm tired, and my head hurts, so will
do it tomorrow.

--

Error handling down, I should have created a dedicated exception class for Platform
errors, but meh, no motivation to do it now.

Will do it later, eventually.

---

### 05-14-2022

Let's start working on the DirectX 12 integration!

---

### 05-15-2022

Desperately looking to get some time to work on this project, but with a child of 3yo
it's like an impossible mission.

---

### 05-18-2022

It's been a while since the last time I update this. I manage to setup the main 
components of Dx12 (factory, device, rtv, swapchain, command queue/alloc/list).

Had to use a `SwapChain3` instead of a classic SwapChain, otherwise I got an exception
after its initialization. Don't have the time to check why.

Now, let's render the clear color.

---

### 05-19-2022

Before rendering the clear color, we need to know _how_ the game will send draw 
calls to the renderer itself. 

The game should not handle direct access to the Renderer methods, or the Engine I 
create will be nothing more than a bunch of C++ header files. I need something 
between the Game logic and the Renderer, and that typically what the Engine is 
designed for.

When you analyze the content of a game loop it's always the same thing: 

1. Wait for your inputs (redraw call, user input, clock tick...)
2. Update your game with the given input
3. Render the new state of the game

Basically, the step 1 and 3 should be delegated to the Engine, which only leaves 
Step 2 to the game itself.

Maybe I should write down a schema of what I've got in mind?

---

### 05-22-2022

Yay background color is correctly drawn \o/ The code smells like shit but it works!

Will take the rest of the day to clean up this mess.

---

### 06-14-2022

Again, it's been a while since the last time I wrote something in this. I finished
the cleanup of the sources, started to implement the display of a hard code mesh, 
and then take a big pause to work on my personal website.

But I want to finish this project and I have the FOMO (_Fear Of Messing Out_) so 
I'm back again before my website is finished...

Let's check where I have left this.

--

Ok took the time but I found I left a bunch of TODOs to explain the various 
steps that I need to do (good boi past-me).

Soooo here's the situation when I left, I created a `Mesh` object in the Engine with 
a `Cube` subclass and hardcoded vertex coords in it. I've also created a `MeshMemory` 
class in the `Dx12Renderer` because I'll need to upload my meshes once in the GPU 
memory, and it should not change that much (it will be the MVP matrix that will 
change between each frame). The `MeshMemory` class is here to keep a trace of which
meshes I already load in Dx12 memory, like a caching system.

Next thing I'll do is to setup a basic display shader and all the satellite objects 
around it (PSO, RootSignature...)

---

### 06-16-2022

Display shader and root signature are done, now I'll check to create the Pipeline
State Object. This thing seems to be important in DirectX12, so I'll dive on the 
purpose of this concept.

--

From what I understood, the PSO is all the information needed to draw a mesh using 
a specific shader (like the shader vertex&pixel bytecode, the entry points of each 
input variables, the topology used to draw -- line, point or triangles --, the blend
state, the rasterizer...).

It makes sense for the moment to keep it close to the shader used, but maybe later 
I'll create a specific class for draw calls, and it will make more sense to put it
in it.

--

PSO is created \o/, got to do a double pointer dereference but hey, I wanted to do 
its low-level style.

Next step: I think I'll create the Constant buffer for storing/passing the MVP 
matrix...

--

Let's talk about the heaps instead. With DirectX 12 there's two kind of buffer heaps
we can used (well, in fact 3, but we'll only need 2 here). Buffer Heaps are buffers 
which can be accessed by the GPU (some kind of GPU VRAM thingy):
* The Upload Heap is a CPU Write / GPU Read buffer 
* The Default Heap is a GPU Read Only buffer.

We can pass all our information (vertex data, index buffers...) through upload heap 
only, but it takes a lot more time for the GPU to read this kind of heap because it 
must make sure that the CPU isn't writing in it at the moment and wait if it does.

It might be useful for data we change often (read: _every frame_ often), like the 
MVP matrix, but for standard Mesh representation vertex (as a reminder, when a shape
change on screen, it does change relatively to its center, it's only its 
representation in the world -- the MVP matrix -- which change), it is a big waste of 
cycles.

For vertex and index buffers, the good thing to do is to load them once in an upload 
heap, then copy them to a default heap, and use only this default heap on the update/
draw calls. Problem is the Copy call between the upload and default heaps are in 
fact GPU commands, so then need to be put in a command list, then submitted and 
flushed.

The idea I have is that on the first update call, when we add a new mesh to the scene, 
it will instead do 2 GPU draw call one to submit the copy, and the second to actually 
render. Then every other call will only do the rendering.

I think I'll written a blog post on how DirectX12 works to render a cube.

Or maybe 2...

--- 

### 06-20-2022

Finished up the draw calls, quite a long step IMHO (and I'm sick of course). Got 
an issue with the `drawIndexed` calls which changed the `sizeInBytes` and `stride` 
values during the call, but it was nothing more than a simple reference omission on a 
return type.

Tomorrow I'll add the depth testing, and I'll start working on the MVP matrix because
I can't see my shape, but I got no errors in the logs, so pretty sure that my 
shape is out of the perspective.

--- 

### 06-22-2022

Pffff I managed to get my shape displayed on the screen. All my previous code 
works, I only have two bugs:

First one, I misplaced my `OMSetRenderTarget` calls, which made me pass the draw 
calls to the command list _then_ set the rendertarget. So, the fact is that I'm always
displaying the previous frame, and never see my mesh. Once moved before the draw calls,
everything worked.

Second one, my mesh keeps changing color again and again. It may be understanable, 
since I use a `rand()` on each color component, but I did it _once_, only in the 
method which loads the Mesh values in the GPU VRam. After some debugs, I see that
my mesh's id is always changing, so the color of my mesh isn't update on each frame,
it's just that I load in VRam a new mesh on each frame (bye bye my beloved memory).
At first, I thought that it has due to a place where I forgot to pass a reference 
and that the code will use the default copy constructor, I rewrote the copy 
constructor of the Mesh object, but it still has this behavior. Then I understood:
On my `DemoGameState`, when I implemented `computeScene`, I create a new `Scene` object
at each call (which is expected because all Scene/frames are idempotent), but I 
also create a new Mesh at each call and that suck. The fix was pretty simple: 
declare the mesh as an attribute of the `DemoGameState`, then pass it to the new 
scene object on each call.

Works, but might need to be extract from the `GameState`... `GameState` should only 
contains the global state of the game, not all the meshs... that the purpose of a 
`Level` (if I take the UnrealEngine vocab.).

Here's what I got for the moment: 

![A Blue window with a multicolored gradient rectangle in it](/projects/avatar/first_draw.jpg)

---

### 06-23-2022

I think that the MVP computation should be done in another branch, this one is 
already huge AF (17 commits apart as main for the moment). I'll only do the light 
refactoring I've noted previously: using namespaces, using uppercase first letter 
for method names, and documenting every class and methods like if I'm clerk at the
most controversial trial.

---

### 07-05-2022

Working exclusively on my personal website, to finish it. Almost done, only the 
comments system to setup. Pat in the back for me.

---

### 07-15-2022

I'll not do the comment system on my website, I don't want this blog to become like
Twitter, Facebook or anything like this. If people like the thing they see, or want 
to discuss with me about it, there's a contact section.

Also Got the Covid last week, still pretty tired now, but no more fever. But the 
website is online now, so let's back to work shall we ?

I've left the work where I displayed a multicolored cube on screen. Well, 
_technically_ I know it's a cube, because of its vertices positions, but on screen 
is a flat rectangle. 

It still miss a proper Model-View-Projection matrix (and a decent rotation) on each 
frame in order to be shown as a 3d cube. I'll start with the easy part : perspective
parameters (fov, aspect ratio, near/far...), the camera position, and the rotation 
setting, then I'll calculate the matrices (this will certainly leads me to a new
Math module), and finally the funny part : inject those matrix into the GPU using a 
Constant buffer.

---

### 07-17-2022

Spend a lot of time today reading about frustum projection, perspective matrices and 
mathematics regarding this.

Of course I still have the possibility to simply import DirectX Math and do a basic 
call to `XMMatrixPerspectiveFovLH` but remember the first purpose of this project:  
I want to _learn_.

It's a bit difficult for the Math part, don't get me wrong, I love math. More specially
I _loved_ maths. But thanks to a duo of math teachers from high school which knows shit 
about Math (one of them is still convinced that `x/y == y/x`, yeah, won 2hours of 
detention after I managed to prove him is wrong...) and are here only to get their salary 
(and thanks for the generations you fucked up aholes !) I developed a basic rejection of 
Mathematics, and I need to learn how to love them again.

Man, I would have loved to have Harold Finch from Person Of Interest as a Math teacher 
(check [this scene](https://www.youtube.com/watch?v=CEfLVCus4iY)).

Anyway, back to the subject, I found [this page](https://www.scratchapixel.com/lessons/3d-basic-rendering/perspective-and-orthographic-projection-matrix/building-basic-perspective-projection-matrix)
which explains how to calculate a basic perspective matrix, and the reasonment behind it.
I'll save it and re-read it later, I think that I need to read it at least twice to 
understand all of it.

---

### 07-19-2022

I implement the perspective matrix calculation. At first I thought that the Math module
will be another plugin of the engine, just like the DirectX or WinRT ones, but it doesn't
fit in it. And there's something that I learn about my work : if it doesn't fit, it doesn't
belong. So I decided to put all the math stuff directly in the Engine, if something will
be platform dependant, I'll use another "plugin" for it (certainly for floating number 
precision), but Math _is_ Math you know ? The mathematic rules doesn't change between a 
GNU/Linux and a Windows.

The sad part is that I won't be able to check if my calculations are correct unless I've 
made the View matrix, combine it with the Projection one, and inject it in the DX renderer.
So here I go, let's continue with the View matrix.

Also, watch the last Jurassic World today (the third one), not a bad movie, not as good as
Jurassic Park (nothing will be as good as Jurassic Park), but a good enterntainment.

Found [this post](https://www.3dgep.com/understanding-the-view-matrix/) about view matrices,
will take a look today.

---

### 07-20-2022

I've read the blog post that I found yesterday, I think that I'll implement a 
LookAt matrix as the view matrix first. In the next version of the program, I'll
implement FPS movements, which means user's inputs treatment and camera yaw/pitch.
That means that I need the camera to be easily switchable.

A LookAt matrix is usually defined with 3 vectors : 
* An `eye` (ie. the origin of the camera)
* A `up` vector for the direction
* A `target` the location where to look at.

The `up` vector is easy, it will always be `(0, 1, 0, 1)` (4 coords in a 3d world 
for homogenous calculations).

If we say that in our world, the origin of it will always be the camera itself 
(for the moment we don't need to support several cameras), we can assume that the 
`eye` will be `(0, 0, 0, 1)`.

Which leaves us only with the `target` and in our case, we want to _display a spinning
cube_, so our `target` will always be the center of our cube, so its _world position_.