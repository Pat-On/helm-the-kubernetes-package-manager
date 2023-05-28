# Summary

------

## Values scope
In Helm, values can be accessed using the dot (.) notation. The tree starts with the outermost dot followed by the child values.

The .Values set
For example, all values that are supplied to the chart both through the values file and through the --set command line flag can be accessed through .Values prefix. So, if you run

helm install myapp01 myapp /path/to/myapp --set service.port.http=8080
Then inside the templates you can access the port using the {{ .Values.service.port.http }}

-------

## Other built-in objects
Helm provides you with other values in addition to the ones provided through the values file and/or the --set flag. Notice that all built-in object names start with capital letters (unlike the .Values set which matches the case state of the value name) For example:

.Release : provides useful information about the release data. For example, .Release.Name outputs the name chosen for the release.

.Capabilities: it provides information about the environment where the chart is to be deployed. For example, .Capabilites.KubeVersion gives the Kubernetes version.

.Chart: all the information that can be found in the Chart.yaml file can be accessed using the .Chart prefix. For example, .Chart.Name for the chart's name.

.Files: provides useful functions to access files and directories in the chart root directory:

.Files.Get reads and outputs the contents of the file that is passed to it. For example, {{ .Files.Get "myfile.json" }}

Files.Glob enumerates the files and directories from the path passed to it as an arguments. For example, Files.Glob config/*. Notice that this function does not read the files, it only returns a files object that can be further processed by other functions.

.AsConfig: works on the files object (see previous bullet point) to add the files to the ConfigMap in suitable format.

.AsSecrets: same as .AsConfig but embeds the files in the Secret format. It also encodes them automatically to base64.

You can find a list of Helm built-in objects in the official documentation: https://helm.sh/docs/chart_template_guide/builtin_objects/#helm

--------

## Templates playground
The NOTES.txt file is normally used to output a help message to the user after the chart is installed or upgraded. But, since it is also rendered by Helm during execution, it can be used to test templates output. The advantage of using NOTES.txt over other templates is that the generated output is not sent to Kubernetes API for validation. This allows you to check for hard-to-find errors in your templates code more easily.

Whenever you want to see the NOTES.txt and other generated templates from Helm without actually applying the result to Kubernetes, you can use the --dry-run command line flag. For example:

helm install myapp01 . --dry-run /path/to/chart

-------

## Template functions


Helm uses the Go programming language as a template engine. Go already has a number of functions that can be used in templates. Helm also makes use of the Sprig library, which offers over 100 function to augment what Go already provides.

Helm functions are used differently than in other programming language. The function is written as follows:

{{ function_name arg1 arg2 ...etc }}
Functions can also accept their input through the pipe symbol (|). For example:

{{ function1 arg | function2 }}
Some of the important functions that you will find (and use) a lot in your templates are:

-: the dash is used to remove whitespaces (including newlines) from before or after the output depending on its position:

{{- .Value.resources }}removes all whitespaces (spaces and newlines) that come before the output.

{{ .Values.resources -}} removes all whitespaces (spaces and newlines) that come after the output.

{{- .Values.resources -}} removes all whitespaces before and after the output.

toYaml: accepts an object as its first parameter and converts it to valid Yaml. For example:

{{ .Values.resources | toYAML }}
Here, .Values.resources is a Go object of type map. The function converts it to YAML format that can be used in a Kubernetes manifest.

indent: indents whatever text passed to it by the number of whitespaces passed to it as an argument. For example:

{{ .Values.resources | toYaml | indent 4 }}
Here the indent function accepts the output of the toYAML function and indents it by four whitespaces.

nindent: does the same task as indent but adds a new line character at the start of the indented block. It's often used with the toYAML function.

b64enc : encodes its input to base64 format. Useful for being used in Secrets.

Flow control with if conditionals
You can instruct Helm to take decisions based on one or more conditions using the if keyword.

It works as follows:

{{- if condition }}
{{ some action if the condition is true }}
{{- else if another condition }}
{{ some other action }}
{{- else }}
{{ if both of the above conditions are false, execute this one }}
if uses a number of functions that allow it to test for conditions. All functions accept their parameters on the same line separated by speaces:

eq equal to

ne not equal to

gt greater than

lt less than

ge greater than or equal

le less than or equal

not reverses the condition of its argument (true returns false and false returns true)

and returns true if both of its arguments are true

or returns true if any of its arguments is true

fail stops chart execution and prints its argument as a friendly message to the user

Looping with range
The range keyword allows to loop over a list or a dictionary (or a mix of both) of values. For example:

Given our values file containing the following:

drinks:
  - coffee
  - tea
  - soda
drinkTypes:
  - name: coffee
    type: hot
  - name: tea
    type: hot
  - name: soda
    type: cold
myDrink:
  morning: coffee
  noon: tea
  evening: soda
{{- range .Values.drinks -}}
{{ . }}
{{- end }}
Returns

coffee
tea
soda
And

{{- range .Values.drink-types -}}
{{ printf "The drink name is %s and its type is %s" .name .type  }}
{{- end}}
Returns

The drink name is coffee and its type is hot
The drink name is tea and its type is hot
The drink name is soda and its type is cold
Finally

{{ range $k,$v := .Values.myDrink }}
{{ printf "In the %s I drink %s." $k $v  }}
{{- end}}
Returns

In the evening I drink soda.
In the morning I drink coffee.
In the noon I drink tea.
Notice the following:

The range keyword limits the scope inside its block to the list's scope. So, in a list of drinks, the . refers directly to the list item. It becomes the root scope. If that list item has child properties of its own, then we can use the . notation to access them. For example .name refers to the name of the currently looped-upon item in the .Values.drinkTypes list.

When iterating over a map (dictionary), we use the $k and $v variables (names are not important), which are populated with the key and value of the item in the map.

-------

## Named templates

Named templates can be thought of as global functions that can be called anywhere in the chart to execute repetitive logic. They are placed in the _helpers.tpl file.

It is highly recommended that you prefix the named template name with the chart name so that no naming collisions occur when using sub charts that happen to use the same names for its own named templates.

A named template starts with the keyword define and end with the end one.

They are called in other templates using the include function. For example:

{{ include myapp.fullname . }}
The include function accepts the first parameter as the name of the named template to call. The second one is the data object that it can use. If we pass . then the named template has access to all the values passed to the chart (.Values, .Release, etc.).