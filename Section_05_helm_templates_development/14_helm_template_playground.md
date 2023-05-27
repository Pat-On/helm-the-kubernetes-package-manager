# 14 Helm templates playground

https://helm.sh/docs/chart_template_guide/builtin_objects/

```
Objects are passed into a template from the template engine. And your code can pass objects around (we'll see examples when we look at the with and range statements). There are even a few ways to create new objects within your templates, like with the tuple function we'll see later.

Objects can be simple, and have just one value. Or they can contain other objects or functions. For example. the Release object contains several objects (like Release.Name) and the Files object has a few functions.

In the previous section, we use {{ .Release.Name }} to insert the name of a release into a template. Release is one of the top-level objects that you can access in your templates.
```

### Note - helm is written in Go language and it is using its templating engine for its template - Go syntax :>



### jump to the NOTES.txt file 
this file is rendered in the same way by go like the other templates. The NOTES are displayed to user at the end of deploying.

Purpose of this file is to provide to user information how to connect to service and how to get access to it. 

```
NAME: playground
LAST DEPLOYED: Sat May 27 18:52:18 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
The name of this chart is playground, its version is 0.1.0
, and the bundled application version is  1.16.0
```

