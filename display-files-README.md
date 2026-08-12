# Display / Workstation Files

The RPGLE source in this case study uses IBM i workstation/display files to drive the interactive screens and subfile-based menus.

## Workstation files explicitly declared in the RPGLE source

| Workstation file | Role supported by the source |
|---|---|
| `lgnmod` | Login/entry screens and related authentication flows. |
| `airmod` | Airline workflow screens; declared with the `manaflt` subfile. |
| `admmod` | Admin workflow screens; declared with multiple subfiles. |
| `usermod` | User workflow screens; declared with `sfr`, `umb`, and `vt` subfiles. |

The source declares these with `dcl-f ... workstn` and uses operations such as `EXFMT`, `WRITE`, and `READC` to interact with the screens and subfiles.

## Subfiles explicitly referenced

### Admin workstation file

`admmod` contains these subfiles:

- `mngairline`
- `mngusr`
- `vwbkpag`
- `vwflt`
- `mngcomp`
- `confset`
- `dltcfset`
- `vbop`
- `vwbook`

### User workstation file

`usermod` contains:

- `sfr`
- `umb`
- `vt`

These subfiles are controlled through relative-record-number variables such as `rrn1`, `rrn2`, `rrn3`, `rrn5`, `rrn6`, `rrn7`, `rrn8`, `rrn11`, `rrn12`, `rrn13`, `rrn20`, and `rrn23`.

## Examples of screen/subfile processing

The RPGLE source shows the typical IBM i interaction pattern:

1. Load records into a subfile with `WRITE`.
2. Display the control format using `EXFMT`.
3. Read changed subfile rows using `READC`.
4. Process the selected option.
5. Use `CHAIN`, `READ`, `SETLL`, `UPDATE`, and other database operations to retrieve or modify related data.

For example, the admin flight-management workflow loads flight records into `vwflt`, displays them through `vwfltctl`, reads selected rows with `READC`, and then supports update/display operations.

## Scope note

This repository documents the workstation-file usage that is explicitly visible in the RPGLE source. The case-study document does not provide complete standalone DDS source members for every display file in the retrieved material, so this documentation does not invent DDS field definitions or screen-format specifications.
