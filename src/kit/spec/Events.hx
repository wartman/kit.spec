package kit.spec;

import kit.Cancellable;
import kit.spec.Result;

final class Events {
	public final onAssertion = new Event<Assertion>();
	public final onSpecComplete = new Event<SpecResult>();
	public final onSuiteComplete = new Event<SuiteResult>();
	public final onComplete = new Event<Result>();
	public final onFailure = new Event<Error>();

	public function new() {}

	public function addReporter(reporter:Reporter):Cancellable {
		return [onAssertion.add(reporter.progress), onComplete.add(reporter.report)];
	}
}
