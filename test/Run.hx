import kit.spec.*;
import kit.spec.reporter.*;

// We're basically testing Kit to test kit.Spec.
// Two birds, one stone, etc.
function main() {
	var reporter = new ConsoleReporter({
		title: 'Kit Tests',
		verbose: true,
		trackProgress: true
	});
	var runner = new Runner();
	runner.addReporter(reporter);

	runner.add(spec.FutureSuite);
	runner.add(spec.TaskSuite);
	runner.add(spec.SugarSuite);
	runner.add(spec.LazySuite);
	runner.add(spec.EventSuite);
	runner.add(spec.ResultSuite);
	runner.add(spec.MaybeSuite);

	runner.run();
}
