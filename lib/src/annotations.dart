class ControllerMethods {
  const ControllerMethods();
}

class POST extends ControllerMethods {
  final String path;
  const POST(this.path);
}

class GET extends ControllerMethods {
  final String path;
  const GET(this.path);
}

class DELETE extends ControllerMethods {
  final String path;
  const DELETE(this.path);
}

class PATCH extends ControllerMethods {
  final String path;
  const PATCH(this.path);
}

class PUT extends ControllerMethods {
  final String path;
  const PUT(this.path);
}

class OPTIONS extends ControllerMethods {
  final String path;
  const OPTIONS(this.path);
}
