public class CommandLineData {
	private String inputFile;
	private String outputFile;
	private boolean addUnderbar;

	private CommandLineData(String inputFile, String outputFile, boolean addUnderbar) {
		this.inputFile = inputFile;
		this.outputFile = outputFile;
		this.addUnderbar = addUnderbar;
	}

	public String getInputFile() {
		return inputFile;
	}

	public String getOutputFile() {
		return outputFile;
	}

	public boolean getAddUnderbar() {
		return addUnderbar;
	}

	public static CommandLineData parse(String[] args) {
		String inputFile = null;
		String outputFile = null;
		boolean addUnderbar = false;
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-i")) {
				if (i + 1 < args.length) {
					inputFile = args[i + 1];
					i++;
				} else {
					throw new IllegalArgumentException("no filename after -i");
				}
			} else if (args[i].equals("-o")) {
				if (i + 1 < args.length) {
					outputFile = args[i + 1];
					i++;
				} else {
					throw new IllegalArgumentException("no filename after -o");
				}
			} else if (args[i].equals("--underbar")) {
				if (i + 1 < args.length) {
					String param = args[i + 1];
					if (param.equals("on")) addUnderbar = true;
					else if (param.equals("off")) addUnderbar = false;
					else throw new IllegalArgumentException("invalid parameter after --underbar");
					i++;
				} else {
					throw new IllegalArgumentException("no parameter after --underbar");
				}
			} else {
				throw new IllegalArgumentException("unknown switch " + args[i]);
			}
		}
		return new CommandLineData(inputFile, outputFile, addUnderbar);
	}
}
