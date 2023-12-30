name: "Apptainer"
scopeName: "source.apptainer"
patterns:
  - match: "(#)(.*)$"
    captures:
      "1":
        name: "comment.line.number-sign.apptainer"
      "2":
        name: "comment.apptainer"
  - match: "^\\s*\\b(?i:({{VALID_HEADERS}}))\\b:?([^#]*)?((#)(.*))?$"
    captures:
      "1":
        name: "keyword.header.apptainer"
      "2":
        name: "string.unquoted.header.apptainer"
      "4":
        name: "comment.line.number-sign.apptainer"
      "5":
        name: "comment.apptainer"
  - match: "^\\s*(%)\\b({{OTHER_SECTIONS}})\\b"
    captures:
      "1":
        name: "punctuation.open.section.apptainer"
      "2":
        name: "entity.name.type.class.apptainer"
  - match: "(\\{\\{)([^}]*)(\\}\\})"
    captures:
      "1":
        name: "punctuation.open.buildarg.apptainer"
      "2":
        name: "variable.readonly.static.buildarg.apptainer"
      "3":
        name: "punctuation.close.buildarg.apptainer"
  - name: "section.shellscript.apptainer"
    begin: "^\\s*(%)\\b({{SHELLSCRIPT_SECTIONS}})\\b([^#]*)?((#)(.*))?$"
    beginCaptures:
      "1":
        name: "punctuation.open.section.apptainer"
      "2":
        name: "entity.name.type.class.apptainer"
      "3":
        name: "string.unquoted.section.apptainer"
      "5":
        name: "comment.line.number-sign.apptainer"
      "6":
        name: "comment.apptainer"
    while: "(^|\\G)(?!\\s*(%).+)"
    contentName: "meta.embedded.block.shellscript"
    patterns:
      - include: "source.shell"
  - name: "section.labels.apptainer"
    begin: "^\\s*(%)\\b({{LABELS_SECTIONS}})\\b([^#]*)?((#)(.*))?$"
    beginCaptures:
      "1":
        name: "punctuation.open.section.apptainer"
      "2":
        name: "entity.name.type.class.apptainer"
      "3":
        name: "string.unquoted.section.apptainer"
      "5":
        name: "comment.line.number-sign.apptainer"
      "6":
        name: "comment.apptainer"
    while: "(^|\\G)(?!\\s*(%).+)"
    patterns:
      - match: "(#)(.*)"
        captures:
          "1":
            name: "punctuation.definition.comment.apptainer"
          "2":
            name: "comment.apptainer"
      - match: "^\\s*([^=[:space:]]+)\\s+(.+)"
        captures:
          "1":
            name: "variable.other.assignment.label.apptainer"
          "2":
            name: "string.unquoted.label.apptainer"
  - name: "section.arguments.apptainer"
    begin: "^\\s*(%)\\b({{ARGUMENTS_SECTIONS}})\\b([^#]*)?((#)(.*))?$"
    beginCaptures:
      "1":
        name: "punctuation.open.section.apptainer"
      "2":
        name: "entity.name.type.class.apptainer"
      "3":
        name: "string.unquoted.section.apptainer"
      "5":
        name: "comment.line.number-sign.apptainer"
      "6":
        name: "comment.apptainer"
    while: "(^|\\G)(?!\\s*(%).+)"
    patterns:
      - match: "(#)(.*)"
        captures:
          "1":
            name: "punctuation.definition.comment.apptainer"
          "2":
            name: "comment.apptainer"
      - match: "^\\s*([^=[:space:]]+)=(.+)"
        captures:
          "1":
            name: "variable.other.assignment.argument.apptainer"
          "2":
            name: "string.unquoted.label.apptainer"
