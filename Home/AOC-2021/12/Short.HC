Bool Foo()
{
  return FALSE;
}

Bool Bar()
{
  return FALSE;
}

U0 Main() {
Foo() || Bar();
}

Uf("Main");