export const cx = (...classes: (string | boolean | null | undefined)[]) =>
  classes.filter(Boolean).join(" ");
