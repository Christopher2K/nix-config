type ContainerProps = {
  children?: JSX.Element | JSX.Element[];
};

export const Container = ({ children }: ContainerProps) => {
  return <box class="container">{children}</box>;
};
