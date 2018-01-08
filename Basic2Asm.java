public class Basic2Asm {
	public static void main(String[] args) {
		CommandLineData commandLineData;
		try {
			commandLineData = CommandLineData.parse(args);
		} catch (IllegalArgumentException e) {
			System.err.println("invalid argument(s): " + e.getMessage());
		}
	}
}
